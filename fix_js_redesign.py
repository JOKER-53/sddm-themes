with open("script.js", "r") as f:
    content = f.read()

import re

# Remove const picker = ...
content = re.sub(r'const picker = \$\("#picker"\);\n', '', content)

# Remove picker button toggling in render()
content = re.sub(r'  \[\.\.\.picker\.children\].*?  \);\n', '', content, flags=re.DOTALL)

# Remove the entire picker population loop
picker_loop = """themes.forEach((t) => {
  const b = document.createElement("button");
  b.dataset.id = t.id;
  b.innerHTML = `${t.name} <span class="pid">${t.id}</span>`;
    b.onclick = () => { 
    currentIndex = themes.findIndex(th => th.id === t.id);
    current = t; 
    render(); 
    pauseAutoplay();
  };
  picker.appendChild(b);
});"""
content = content.replace(picker_loop, '')

with open("script.js", "w") as f:
    f.write(content)
