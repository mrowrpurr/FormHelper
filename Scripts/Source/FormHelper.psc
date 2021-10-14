scriptName FormHelper hidden

; Returns the provided hexadecimal string as a decimal integer value.
int function HexToInt(string hex) global
    int decimal = 0

    int base = 1
    int hexLength = StringUtil.GetLength(hex)
    int index = hexLength - 1

    while index >= 0
        string character = StringUtil.Substring(hex, index, 1)
        int characterValue = StringUtil.AsOrd(character)
        if (characterValue >= 48 && characterValue <= 57) ; 0 - 9
            decimal += (characterValue - 48) * base
            base *= 16
        elseIf (characterValue >= 65 && characterValue <= 70) ; A - F
            decimal += (characterValue - 55) * base
            base *= 16
        endIf
        index -= 1
    endWhile

    return decimal
endFunction

; Returns the provided decimal integer value as a hexadecimal string.
string function IntToHex(int decimal) global
    string hex = ""

    int[] hexValues = new int[128]
    int quotient = decimal
    int i=1
    int temp

    while quotient != 0
        temp = quotient % 16
        if temp < 10
            temp += 48
        else
            temp += 55
        endIf
        hexValues[i] = temp
        i += 1
        quotient = quotient / 16
    endWhile

    i -= 1
    while i > 0
        hex += StringUtil.AsChar(hexValues[i])
        i -= 1
    endWhile

    return hex
endFunction

; Returns the provided Form ID decimal integer value as a Skyrim Form hexadecimal string.
;
; Intended to be called only with Skyrim Form ID values.
; Use `IntToHex()` for regular decimal to hexadecimal conversion.
;
; The resulting hexadecimal string will be 8 characters long.
;
; Full Plugins:  xx000000 where xx is the mod index
; Light Plugins: FExxx000 where xxx is the light mod index
string function FormIdToHex(int decimal) global
    int minHexStringLength = 8
    bool isLight = false
    int lightModIndex

    if decimal < 0
        ; Light mods have negative Form IDs
        isLight = true
        ; Get the main Form ID from this light mod's negative Form ID (without mod index)
        decimal = Math.LogicalAnd(decimal, 0xFFF) 
        ; Get just the mod index from this light mod's negative Form ID
        lightModIndex = Math.RightShift(Math.LogicalAnd(decimal, 16773120), 12) ; (x00FF000 & formID) >> 12
    endIf

    string hex = IntToHex(decimal)

    if isLight && minHexStringLength == 8
        minHexStringLength = 3 ; First 5 characters will be added below: FE xyz
    endIf

    int zeroPaddingPrefixCount = minHexStringLength - StringUtil.GetLength(hex)
    if zeroPaddingPrefixCount > 0
        int i = 0
        while i < zeroPaddingPrefixCount
            hex = "0" + hex
            i += 1
        endWhile
    endIf

    if isLight
        string modIndexText = IntToHex(lightModIndex)
        hex = modIndexText + hex
        int modIndexTextLength = StringUtil.GetLength(modIndexText)
        int zerosToAdd = 3 - modIndexTextLength
        int i = 0
        while i < zerosToAdd
            hex = "0" + hex
            i += 1
        endWhile
        hex = "FE" + hex
    endIf

    return hex
endFunction

; Get the hexadecimal Skyrim string for this Form.
string function FormToHex(Form aForm) global
    return FormIdToHex(aForm.GetFormID())
endFunction

; Provide a hex Form ID, e.g. `F` or `0000000F` or `17000d62` or `FE003801`
; Works with the base game, DLCs, full plugins, and light plugins.
; Returns a Form.
Form function HexToForm(string hex) global
    int len = StringUtil.GetLength(hex)
    if len == 8
        if StringUtil.Find(hex, "FE") == 0
            int formId = HexToInt(StringUtil.Substring(hex, 5, 3))
            return Game.GetFormFromFile(formId, HexToModName(hex))
        else
            int formId = HexToInt(StringUtil.Substring(hex, 2, 6))
            return Game.GetFormFromFile(formId, HexToModName(hex))
        endIf
    else
        return Game.GetForm(HexToInt(hex))
    endIf
endFunction

; Provide a hex Form ID, e.g. `F` or `0000000F` or `17000d62` or `FE003801`
; Works with the base game, DLCs, full plugins, and light plugins.
; Returns the full name of the name, e.g. `skyrim.esm`, `Dawnguard.esm`, `SomePlugin.esp`
string function HexToModName(string hex) global
    int len = StringUtil.GetLength(hex)
    if len == 8
        if StringUtil.Find(hex, "FE") == 0
            return Game.GetLightModName(HexToInt(StringUtil.Substring(hex, 2, 3)))
        else
            return Game.GetModName(HexToInt(StringUtil.Substring(hex, 0, 2)))
        endIf
    else
        return "skyrim.esm"
    endIf
endFunction

; doc
string function FormToModName(Form aForm) global

endFunction

; doc
bool function IsLightMod(string modPlugin) global
endFunction

; doc
bool function IsLightModHex(string hex) global
endFunction

; doc
bool function IsLightModForm(Form aForm) global
endFunction

; Returns the Mod Index for the provided Form as a hexadecimal string.
;
; For full plugins, this will be 2 characters long.
; For light plugins, this will be 3 characters long.
;
; To use this with `Game.GetModName()` or `Game.GetLightModName()`
; convert the return value to a decimal via `HexToInt()`
string function GetModIndexTextFromForm(Form aForm) global

endFunction
