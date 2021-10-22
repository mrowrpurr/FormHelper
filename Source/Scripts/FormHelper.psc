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
; Dynamic forms: FF000xxx
string function FormIdToHex(int decimal) global
    string rawHex = IntToHex(decimal * -1)
    int minHexStringLength = 8
    bool isLight = false
    int lightModIndex

    if decimal < 0
        ; Light mods have negative Form IDs
        isLight = true
        ; Get just the mod index from this light mod's negative Form ID
        lightModIndex = Math.RightShift(Math.LogicalAnd(decimal, 16773120), 12) ; (x00FF000 & formID) >> 12
        ; Get the main Form ID from this light mod's negative Form ID (without mod index)
        decimal = Math.LogicalAnd(decimal, 0xFFF) 
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
        if StringUtil.Substring(rawHex, 0, 2) == "FF" ; Dynamically allocated
            hex = "FF" + hex
        else
            hex = "FE" + hex
        endIf
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
        elseIf StringUtil.Find(hex, "FF") == 0
            ; As far as I can tell, there is no way to get dynamically allocated forms
            ; via their ID using GetForm() or GetFormFromFile() etc.
            ; If anyone knows, let me know! I tried GetForm() and GetFormFromFile(id, "") etc.
            return None
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
        elseIf StringUtil.Find(hex, "FF") == 0
            return "" ; Dynamically allocated forms have no associated mod name
        else
            return Game.GetModName(HexToInt(StringUtil.Substring(hex, 0, 2)))
        endIf
    else
        return "skyrim.esm"
    endIf
endFunction

; Returns the mod name which the provided Form comes from.
string function FormToModName(Form aForm) global
    return HexToModName(FormToHex(aForm))
endFunction

; Returns true if the provided .esm/.esp is a light plugun.
; Provide the full mod name, e.g. "MyMod.esp"
bool function IsLightMod(string modPlugin) global
    return Game.GetLightModByName(modPlugin) != 65535
endFunction

; Returns true of the provided string hex Form ID comes from a light mod.
bool function IsLightModHex(string hex) global
    return StringUtil.Find(hex, "FE") == 0
endFunction

; Returns true if the provided Form comes from a light mod.
bool function IsLightModForm(Form aForm) global
    return aForm.GetFormID() < 0
endFunction

; Returns the mod's index, extracted from the provided Form ID hex.
int function HexToModIndex(string hex) global
    int len = StringUtil.GetLength(hex)
    if len == 8
        if StringUtil.Find(hex, "FE") == 0
            return HexToInt(StringUtil.Substring(hex, 2, 3))
        elseIf StringUtil.Find(hex, "FF") == 0
            return 0 ; Dynamically allocated forms have no associated mod
        else
            return HexToInt(StringUtil.Substring(hex, 0, 2))
        endIf
    else
        return 0
    endIf
endFunction

; Returns a hex string representation of the mod's index,
; extracted from the provided Form ID hex.
string function HexToModIndexHex(string hex) global
    int len = StringUtil.GetLength(hex)
    if len == 8
        if StringUtil.Find(hex, "FE") == 0
            return StringUtil.Substring(hex, 2, 3)
        elseIf StringUtil.Find(hex, "FF") == 0
            return "000"
        else
            return StringUtil.Substring(hex, 0, 2)
        endIf
    else
        return "00"
    endIf
endFunction

; Returns the Mod Index for the provided Form.
; Can be used to call `Game.GetModName()` or `Game.GetLightModName()` etc.
; You can use `IsLightModForm()` to see if the mod index is for a light mod.
int function FormToModIndex(Form aForm) global
    return HexToInt(FormToModIndexHex(aForm))
endFunction

; Returns the Mod Index for the provided Form as a hexadecimal string.
;
; For full plugins, this will be 2 characters long.
; For light plugins, this will be 3 characters long.
;
; To use this with `Game.GetModName()` or `Game.GetLightModName()`
; convert the return value to a decimal via `HexToInt()`
string function FormToModIndexHex(Form aForm) global
    return HexToModIndexHex(FormToHex(aForm))
endFunction
