language_table = {["hall_of_heroes:entry_walltext"] = "Choose, whom fate will carry away with it."}

function translate(text)
    local token = string.sub(text, 7, -1)
    local translated_text = language_table[token]    
    return translated_text
end