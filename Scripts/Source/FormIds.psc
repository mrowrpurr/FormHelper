scriptName FormIds hidden

; doc
int function HexToInt(string hex) global
    return HexToDecimal(hex)
endFunction

; doc
int function FormToInt(Form aForm) global
    return aForm.GetFormID()
endFunction

; doc
string function IntToHex(int decimal) global
    return DecimalToHex(decimal)
endFunction

; doc
string function FormToHex(Form aForm) global
    return DecimalToHex(aForm.GetFormID())
endFunction

; doc
Form function HexToForm(string hex) global
    ; int length = StringUtil.GetLength(hex)
    ; if length == 8
    ;     if StringUtil.Find(hex, "FE") == 0

    ;     else

    ;     endIf
    ; else
    ;     return Game.GetForm(HexToDecimal(hex))
    ; endIf
endFunction

; doc
Form function IntToForm(int decimal) global
    ; TODO TODO TODO TODO TODO
endFunction

; doc
string function HexToStringFormat() global
endFunction

; doc
string function IntToStringFormat() global
endFunction

; doc
string function FormToStringFormat() global
endFunction

; doc
bool function IsModLightInt() global
endFunction

; doc
bool function IsModLightHex() global
endFunction

; doc
bool function IsModLightForm() global
endFunction

; doc
string function GetModNameFromHex(string hex) global
    int len = StringUtil.GetLength(hex)
    if len == 8
        if StringUtil.Find(hex, "FE") == 0
            int modIndex = StringUtil.Substring(2, 3) as int
            return Game.GetLightModName(modIndex)
        else
            int modIndex = StringUtil.Substring(0, 2) as int
            return Game.GetModName(modIndex)
        endIf
    else
        return "skyrim.esm"
    endIf
endFunction

; doc
string function GetModNameFromInt() global
endFunction

; doc
string function GetModNameFromForm() global
endFunction

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

; Returns the ASCII character for the provided decimal value.
; Only supports 48-57 ("0"-"9") and 65-70 ("A"-"F")
string function ValueToChar(int value) global
    if value == 48
        return "0"
    elseIf value == 49
        return "1"
    elseIf value == 50
        return "2"
    elseIf value == 51
        return "3"
    elseIf value == 52
        return "4"
    elseIf value == 53
        return "5"
    elseIf value == 54
        return "6"
    elseIf value == 55
        return "7"
    elseIf value == 56
        return "8"
    elseIf value == 57
        return "9"
    elseIf value == 65
        return "A"
    elseIf value == 66
        return "B"
    elseIf value == 67
        return "C"
    elseIf value == 68
        return "D"
    elseIf value == 69
        return "E"
    elseIf value == 70
        return "F"
    else
        return ""
    endIf
endFunction

; Returns the ASCII decimal value for the provided character
; Only supports "0"-"9" (48-57) and "A"-"F" (65-70)
int function CharToValue(string char) global
    if char == "0"
        return 48
    elseIf char == "1"
        return 49
    elseIf char == "2"
        return 50
    elseIf char == "3"
        return 51
    elseIf char == "4"
        return 52
    elseIf char == "5"
        return 53
    elseIf char == "6"
        return 54
    elseIf char == "7"
        return 55
    elseIf char == "8"
        return 56
    elseIf char == "9"
        return 57
    elseIf char == "A"
        return 65
    elseIf char == "B"
        return 66
    elseIf char == "C"
        return 67
    elseIf char == "D"
        return 68
    elseIf char == "E"
        return 69
    elseIf char == "F"
        return 70
    else
        return -1
    endIf
endFunction

; Returns the provided hexadecimal string as a decimal integer value
int function HexToDecimal(string hex) global
    int decimal = 0

    int base = 1
    int hexLength = StringUtil.GetLength(hex)
    int index = hexLength - 1

    while index >= 0
        string character = StringUtil.Substring(hex, index, 1)
        int characterValue = CharToValue(character)
        if characterValue == -1
            Debug.Trace("[FormIds] HexToDecimal() Invalid hex string provided: " + hex)
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

; TODO make *SURE* this returns an 8-length string!!!!!
;
; Returns the provided decimal integer value as a hexadecimal string
string function DecimalToHex(int decimal, int minHexStringLength = 8) global
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
            Debug.Trace("[FormIds] DecimalToHex() Provided decimal too large to convert: " + decimal)
            return ""
        endIf

        quotient = quotient / 16
    endWhile

    i -= 1
    while i > 0
        hex += ValueToChar(hexValues[i])
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

    return hex
endFunction