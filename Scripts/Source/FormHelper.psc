scriptName FormHelper hidden

; Returns the provided hexadecimal string as a decimal integer value.
int function HexToDecimal(string hex) global
    int decimal = 0

    int base = 1
    int hexLength = StringUtil.GetLength(hex)
    int index = hexLength - 1

    while index >= 0
        string character = StringUtil.Substring(hex, index, 1)
        int characterValue = StringUtil.AsOrd(character)
        if characterValue == -1
            Debug.Trace("[FormHelper] HexToDecimal() Invalid hex string provided: " + hex)
            return -1
        endIf
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
;
; By default, the string will be at least 8 characters long by adding
; front-leading padding of zero `"0"` values (_to match Skyrim standard hex values_).
string function DecimalToHex(int decimal, int minHexStringLength = 8) global
    int originalDecimal = decimal

    bool isLight = false
    if decimal < 0
        isLight = true
        decimal = Math.LogicalAnd(decimal, 0xFFF) ; ESL Form ID
    endIf

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

        if i > 128
            ; I don't actually think this is actually possible?
            Debug.Trace("[FormHelper] DecimalToHex() Provided decimal too large to convert: " + decimal)
            return ""
        endIf

        quotient = quotient / 16
    endWhile

    i -= 1
    while i > 0
        hex += StringUtil.AsChar(hexValues[i])
        i -= 1
    endWhile

    int zeroPaddingPrefixCount = minHexStringLength - StringUtil.GetLength(hex)
    if zeroPaddingPrefixCount > 0
        i = 0
        while i < zeroPaddingPrefixCount
            hex = "0" + hex
            i += 1
        endWhile
    endIf

    if isLight
        ; string modIndexText = (Math.LogicalAnd(decimal, 0x0F)) + 1
        ; hex = modIndexText + StringUtil.Substring(hex, 3)

        string modIndexText = IntToHex(originalDecimal - decimal)

        int modIndexTextLength = StringUtil.GetLength(modIndexText)
        
        int zerosToAdd = 3 - modIndexTextLength
        i = 0
        while i < zerosToAdd
            hex = "0" + hex
            i += 1
        endWhile
        return "FE" + hex
    else
        return hex
    endIf
endFunction

; Alias for `HexToDecimal()`
int function HexToInt(string hex) global
    return HexToDecimal(hex)
endFunction

; doc
int function FormToInt(Form aForm) global
    return aForm.GetFormID()
endFunction

; Alias for `DecimalToHex()`
string function IntToHex(int decimal) global
    return DecimalToHex(decimal)
endFunction

; ...
string function FormToHex(Form aForm) global
    return DecimalToHex(aForm.GetFormID())
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
        return Game.GetForm(HexToDecimal(hex))
    endIf
endFunction

; Provide a hex Form ID, e.g. `F` or `0000000F` or `17000d62` or `FE003801`
; Works with the base game, DLCs, full plugins, and light plugins.
; Returns the full name of the name, e.g. `skyrim.esm`, `Dawnguard.esm`, `SomePlugin.esp`
string function HexToModName(string hex) global
    int len = StringUtil.GetLength(hex)
    if len == 8
        if StringUtil.Find(hex, "FE") == 0
            return Game.GetLightModName(HexToDecimal(StringUtil.Substring(hex, 2, 3)))
        else
            return Game.GetModName(HexToDecimal(StringUtil.Substring(hex, 0, 2)))
        endIf
    else
        return "skyrim.esm"
    endIf
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ; doc
; bool function IsModLightHex() global
; endFunction

; ; doc
; bool function IsModLightForm() global
; endFunction

; doc
int function GetModIndexFromHex() global
endFunction

; doc
int function GetModIndexFromInt() global
endFunction

; doc
int function GetModIndexFromForm() global
endFunction

; doc
string function GetModHexPrefixFromHex(string hex) global
    int len = StringUtil.GetLength(hex)
    if len == 8
        if StringUtil.Find(hex, "FE") == 0
            return StringUtil.Substring(2, 3)
        else
            return StringUtil.Substring(0, 2)
        endIf
    else
        return "00"
    endIf
endFunction

; doc
string function GetModHexPrefixFromInt(int decimal) global
    ; DecimalToHex()
endFunction

; doc
string function GetModHexPrefixFromForm(Form aForm) global
endFunction
