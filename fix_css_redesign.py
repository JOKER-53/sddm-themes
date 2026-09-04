with open("styles.css", "r") as f:
    content = f.read()

# Replace stage
content = content.replace(
    '.stage { display: grid; grid-template-columns: 1fr 420px; gap: 24px; max-width: 98%; margin: 32px auto; padding: 0 1vw; }',
    '.stage { display: block; max-width: 90%; margin: 32px auto; }'
)
# Make stage responsive so it's not massive vertically
content = content.replace(
    '.preview { position: sticky; top: 32px; height: calc(100vh - 64px); border: 1px solid var(--line); border-radius: 8px; background: #000 center/cover no-repeat; overflow: hidden; color: #fff; font-family: ui-monospace, "JetBrains Mono", monospace; }',
    '.preview { position: relative; aspect-ratio: 16/9; max-height: 80vh; margin: 0 auto; border: 1px solid var(--line); border-radius: 12px; background: #000 center/cover no-repeat; overflow: hidden; color: #fff; font-family: ui-monospace, "JetBrains Mono", monospace; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5); }'
)

# Replace picker (remove it)
import re
content = re.sub(r'\.picker \{.*?\}\n', '', content)
content = re.sub(r'\.picker button \{.*?\}\n', '', content)
content = re.sub(r'\.picker button:hover \{.*?\}\n', '', content)
content = re.sub(r'\.picker button\.active \{.*?\}\n', '', content)
content = re.sub(r'\.picker \.pid \{.*?\}\n', '', content)
content = re.sub(r'\/\* Custom Scrollbar for Picker \*\/\n.*?\}', '', content, flags=re.DOTALL)

# Adjust Grid
content = content.replace(
    '.grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 12px; max-width: 1200px; margin: 48px auto; padding: 0 6vw; }',
    '.grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 24px; max-width: 90%; margin: 64px auto; padding: 0; }'
)
content = content.replace(
    '.card { position: relative; aspect-ratio: 16/10; border: 1px solid var(--line); background: #000 center/cover no-repeat; cursor: pointer; overflow: hidden; }',
    '.card { position: relative; aspect-ratio: 16/9; border: 1px solid var(--line); border-radius: 8px; background: #000 center/cover no-repeat; cursor: pointer; overflow: hidden; transition: transform 0.2s, box-shadow 0.2s; }'
)
content = content.replace(
    '.card:hover { outline: 1px solid var(--accent); }',
    '.card:hover { outline: 2px solid var(--accent); transform: translateY(-4px); box-shadow: 0 10px 20px rgba(0,0,0,0.4); }'
)
content = content.replace(
    '.card::after { content: attr(data-name); position: absolute; left: 8px; bottom: 6px; color: #fff; font-size: 11px; letter-spacing: .15em; text-shadow: 0 1px 2px #000; }',
    '.card::after { content: attr(data-name); position: absolute; inset: auto 0 0 0; padding: 16px 12px 10px; background: linear-gradient(transparent, rgba(0,0,0,0.9)); color: #fff; font-size: 14px; font-weight: bold; letter-spacing: .1em; }'
)

with open("styles.css", "w") as f:
    f.write(content)

