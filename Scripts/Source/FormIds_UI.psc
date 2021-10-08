scriptName FormIds_UI extends Quest  

FormIds_UI function GetInstance() global
    return Game.GetFormFromFile(0x800, "FormIds_UI.esp") as FormIds_UI
endFunction

function ShowUI()
    UIListMenu menu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
    menu.AddEntryItem("Hex to Decimal")
    menu.AddEntryItem("Hex to Form")
    menu.AddEntryItem("Hex to Mod Name")
    menu.AddEntryItem("Decimal to Hex")
    menu.AddEntryItem("Char to Decimal")
    menu.OpenMenu()

    int hexToDecimal = 0
    int hexToForm = 1
    int hexToModName = 2
    int decimalToHex = 3
    int charToDecimal = 4
    int selected = menu.GetResultInt()
    if selected == hexToDecimal
        HexToDecimalUI()
    elseIf selected == hexToForm
        HexToFormUI()
    elseIf selected == hexToModName
        HexToModNameUI()
    elseIf selected == decimalToHex
        DecimalToHexUI()
    elseIf selected == charToDecimal
        CharToDecimalUI()
    endIf
endFunction

function HexToDecimalUI()
    Debug.MessageBox(FormIds.HexToDecimal(GetUserText()))
endFunction

function HexToFormUI()
    Debug.MessageBox(FormIds.HexToForm(GetUserText()))
endFunction

function DecimalToHexUI()
    Debug.MessageBox(FormIds.DecimalToHex(GetUserText() as int))
endFunction

function HexToModNameUI()
    Debug.MessageBox(FormIds.GetModNameFromHex(GetUserText()))
endFunction

function CharToDecimalUI()
    Debug.MessageBox(FormIds.CharToValue(GetUserText()))
endFunction

string function GetUserText()
    UITextEntryMenu menu = UIExtensions.GetMenu("UITextEntryMenu") as UITextEntryMenu
    menu.OpenMenu()
    return menu.GetResultString()
endFunction
