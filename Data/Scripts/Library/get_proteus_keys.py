import re

def extract_top_level_keys(file_path, output_txt_path):
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    prefix_match = re.search(r"^\s*return\s*\{", content, re.MULTILINE)
    if not prefix_match:
        print("Error")
        return

    body = content[prefix_match.end() :]

    top_keys = []
    i = 0

    while i < len(body):
        match = re.match(r'\s*\[\s*["\']([^"\']+)["\']\s*\]\s*=\s*\{', body[i:])

        if match:
            key_name = match.group(1)
            top_keys.append(key_name)

            start_brace = body.find("{", i)
            depth = 1
            idx = start_brace + 1
            in_string = False
            string_char = ""

            while idx < len(body) and depth > 0:
                char = body[idx]
                
                if char in ('"', "'") and (idx == 0 or body[idx - 1] != "\\"):
                    if not in_string:
                        in_string = True
                        string_char = char
                    elif string_char == char:
                        in_string = False
                
                if (
                    not in_string
                    and char == "-"
                    and idx + 1 < len(body)
                    and body[idx + 1] == "-"
                ):
                    line_end = body.find("\n", idx)
                    idx = len(body) if line_end == -1 else line_end
                    continue

                if not in_string:
                    if char == "{":
                        depth += 1
                    elif char == "}":
                        depth -= 1

                idx += 1

            i = idx
        else:
            i += 1

    with open(output_txt_path, "w", encoding="utf-8") as f:
        for key in top_keys:
            f.write(f"{key}\n")

extract_top_level_keys("C:/Eleian/EawxSubmods/Project-Proteus/Data/Scripts/Library/ProteusWarlordLibrary.lua", "C:/Eleian/EawxSubmods/Project-Proteus/keys_list.txt")