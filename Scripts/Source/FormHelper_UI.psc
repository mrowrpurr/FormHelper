scriptName FormHelper_UI extends Quest  

FormHelper_UI function GetInstance() global
    return Game.GetFormFromFile(0x800, "FormHelper_UI.esp") as FormHelper_UI
endFunction

function ShowUI()
    UIListMenu menu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
    menu.AddEntryItem("Hex to Decimal")
    menu.AddEntryItem("Hex to Form")
    menu.AddEntryItem("Hex to Mod Name")
    menu.AddEntryItem("Decimal to Hex")
    menu.AddEntryItem("Form to Hex")
    menu.OpenMenu()

    int hexToDecimal = 0
    int hexToForm = 1
    int hexToModName = 2
    int decimalToHex = 3
    int formToHex = 4
    int selected = menu.GetResultInt()
    if selected == hexToDecimal
        HexToDecimalUI()
    elseIf selected == hexToForm
        HexToFormUI()
    elseIf selected == hexToModName
        HexToModNameUI()
    elseIf selected == decimalToHex
        DecimalToHexUI()
    elseIf selected == formToHex
        FormToHexUI()
    endIf
endFunction

function HexToDecimalUI()
    Debug.MessageBox(FormHelper.HexToDecimal(GetUserText()))
endFunction

function HexToFormUI()
    Debug.MessageBox(FormHelper.HexToForm(GetUserText()))
endFunction

function DecimalToHexUI()
    Debug.MessageBox(FormHelper.DecimalToHex(GetUserText() as int))
endFunction

function HexToModNameUI()
    Debug.MessageBox(FormHelper.HexToModName(GetUserText()))
endFunction

function FormToHexUI()
    ; Get a form
    Form aForm = FormHelper.HexToForm(GetUserText())
    Debug.MessageBox(aForm + " " + aForm.GetName() + " " + aForm.GetFormID())
    Debug.MessageBox(FormHelper.FormToHex(aForm))
endFunction

string function GetUserText()
    UITextEntryMenu menu = UIExtensions.GetMenu("UITextEntryMenu") as UITextEntryMenu
    menu.OpenMenu()
    return menu.GetResultString()
endFunction
