import configparser
import fcntl
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import install
import mp4_to_gif


class InstallerTests(unittest.TestCase):
    def test_unsafe_theme_ids_are_rejected(self):
        for value in ("../marvel", "../../../../tmp/theme", "/tmp/theme", "marvel/", "unknown", "marvel;id"):
            with self.subTest(value=value), self.assertRaises(ValueError):
                install.theme_source(value)

    def test_section_update_preserves_unrelated_values(self):
        text = "[Autologin]\nCurrent=keep\nUser=alice\n[Theme]\n# comment\nCurrent=old\nCursorTheme=breeze\n[General]\nCurrent=also-keep\n"
        result = install.set_ini_value(text, "Theme", "Current", "marvel")
        self.assertIn("Current=keep", result)
        self.assertIn("Current=also-keep", result)
        self.assertIn("# comment", result)
        self.assertIn("CursorTheme=breeze", result)
        self.assertIn("[Theme]\n# comment\nCurrent=marvel", result)

    def test_qt_metadata_is_replaced_for_both_runtimes(self):
        for qt in (5, 6):
            with self.subTest(qt=qt), tempfile.TemporaryDirectory() as directory:
                stage = Path(directory) / "theme"
                install.prepare_theme(install.theme_source("marvel"), stage, qt)
                conf = configparser.ConfigParser()
                conf.read(stage / "metadata.desktop")
                self.assertEqual(conf.get("SddmGreeterTheme", "QtVersion"), str(qt))

    def test_conversion_failure_preserves_existing_theme_and_configuration(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            live = root / "usr/share/sddm/themes/marvel"
            live.mkdir(parents=True)
            (live / "sentinel").write_text("old theme")
            conf = root / "etc/sddm.conf"
            conf.parent.mkdir()
            conf.write_text("[Theme]\nCurrent=marvel\n")
            with patch.object(install, "prepare_theme", side_effect=RuntimeError("FFmpeg failed")):
                with self.assertRaisesRegex(RuntimeError, "FFmpeg failed"):
                    install.install_theme(install.theme_source("marvel"), "marvel", 6, root)
            self.assertEqual((live / "sentinel").read_text(), "old theme")
            self.assertEqual(conf.read_text(), "[Theme]\nCurrent=marvel\n")
            self.assertEqual(list(live.parent.glob(".marvel-*")), [])

    def test_configuration_publish_failure_rolls_back_theme(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            live = root / "usr/share/sddm/themes/marvel"
            live.mkdir(parents=True)
            (live / "sentinel").write_text("old theme")
            conf = root / "etc/sddm.conf"
            conf.parent.mkdir()
            conf.write_text("[Theme]\nCurrent=old\n")
            with patch.object(install.os, "replace", side_effect=OSError("Cannot publish config")):
                with self.assertRaises(OSError):
                    install.install_theme(install.theme_source("marvel"), "marvel", 6, root)
            self.assertEqual((live / "sentinel").read_text(), "old theme")
            self.assertEqual(conf.read_text(), "[Theme]\nCurrent=old\n")
            self.assertEqual(list(conf.parent.glob(".sddm-conf-*")), [])

    def test_success_preserves_backup_and_selects_theme(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            live = root / "usr/share/sddm/themes/marvel"
            live.mkdir(parents=True)
            (live / "sentinel").write_text("old theme")
            destination, backup = install.install_theme(install.theme_source("marvel"), "marvel", 6, root)
            self.assertTrue((destination / "Main.qml").is_file())
            self.assertEqual((backup / "sentinel").read_text(), "old theme")
            self.assertIn("Current=marvel", (root / "etc/sddm.conf").read_text())

    def test_symlink_destination_is_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            base = root / "usr/share/sddm/themes"
            base.mkdir(parents=True)
            outside = root / "outside"
            outside.mkdir()
            (base / "marvel").symlink_to(outside, target_is_directory=True)
            with self.assertRaisesRegex(ValueError, "symlink"):
                install.install_theme(install.theme_source("marvel"), "marvel", 6, root)
            self.assertEqual(list(outside.iterdir()), [])

    def test_concurrent_install_is_rejected_before_changing_theme(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            base = root / "usr/share/sddm/themes"
            base.mkdir(parents=True)
            with (base / ".install.lock").open("w") as lock:
                fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
                with self.assertRaisesRegex(RuntimeError, "Another theme installation"):
                    install.install_theme(install.theme_source("marvel"), "marvel", 6, root)
            self.assertFalse((base / "marvel").exists())

    def test_qt6_debian_modules_include_controls_and_layouts(self):
        packages = install.dependency_packages("apt", 6)
        self.assertIn("qml6-module-qtquick-controls", packages)
        self.assertIn("qml6-module-qtquick-layouts", packages)

    def test_unsuffixed_qt6_greeter_is_supported(self):
        def which(name):
            return "/usr/bin/sddm-greeter" if name == "sddm-greeter" else None
        with patch.object(install.shutil, "which", side_effect=which), patch.object(install.subprocess, "run", return_value=subprocess.CompletedProcess([], 0, "libQt6Core.so.6", "")):
            self.assertEqual(install.greeter_name(6), "sddm-greeter")
            with self.assertRaises(RuntimeError):
                install.greeter_name(5)

    def test_package_install_failure_propagates(self):
        def which(name):
            return "/usr/bin/apt" if name == "apt" else None
        def run(command, **kwargs):
            if command[0] == "dpkg-query":
                return subprocess.CompletedProcess(command, 0, "deinstall ok config-files", "")
            raise subprocess.CalledProcessError(1, command)
        with patch.object(install.shutil, "which", side_effect=which), patch.object(install.subprocess, "run", side_effect=run):
            with self.assertRaises(subprocess.CalledProcessError):
                install.check_dependencies(6)

    def test_failed_conversion_preserves_previous_output(self):
        with tempfile.TemporaryDirectory() as directory:
            input = Path(directory) / "video.mp4"
            input.write_bytes(b"invalid video")
            output = Path(directory) / "wallpaper.gif"
            output.write_bytes(b"existing gif")
            with patch.object(mp4_to_gif.shutil, "which", return_value="ffmpeg"), patch.object(mp4_to_gif.subprocess, "run", return_value=subprocess.CompletedProcess([], 1, "", "bad input")):
                with self.assertRaisesRegex(RuntimeError, "bad input"):
                    mp4_to_gif.convert_mp4_to_gif(input, output)
            self.assertEqual(output.read_bytes(), b"existing gif")
            self.assertEqual(list(Path(directory).glob(".sddm-gif-*")), [])


if __name__ == "__main__":
    unittest.main()
