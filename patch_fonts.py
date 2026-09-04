with open("index.html", "r") as f:
    html = f.read()

new_fonts = ["Mali", "Orbitron", "Cinzel", "Yusei+Magic", "Patrick+Hand", "Shojumaru", "Russo+One", "Comfortaa", "Pacifico", "Pirata+One", "VT323", "Chewy"]
link = f'<link href="https://fonts.googleapis.com/css2?family={"&family=".join(new_fonts)}&display=swap" rel="stylesheet">'

if "Orbitron" not in html:
    html = html.replace("</head>", f"  {link}\n</head>")
    with open("index.html", "w") as f:
        f.write(html)
