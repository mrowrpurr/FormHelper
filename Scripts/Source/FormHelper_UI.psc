scriptName FormHelper_UI extends Quest  

FormHelper_UI function GetInstance() global
    return Game.GetFormFromFile(0x800, "FormHelper_UI.esp") as FormHelper_UI
endFunction

function ShowUI()
    UIListMenu menu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
    menu.AddEntryItem("Hex to Int")
    menu.AddEntryItem("Int to Hex")
    menu.AddEntryItem("Form ID to Hex")
    menu.AddEntryItem("Form to Hex")
    menu.AddEntryItem("Hex to Form")
    menu.AddEntryItem("Hex to Mod Name")
    menu.AddEntryItem("Form to Mod Name")
    menu.AddEntryItem("IsLightMod")
    menu.AddEntryItem("IsLightModHex")
    menu.AddEntryItem("IsLightModForm")
    menu.AddEntryItem("Hex To Mod Index")
    menu.AddEntryItem("Hex To Mod Index Hex")
    menu.AddEntryItem("Form To Mod Index")
    menu.AddEntryItem("Form to Mod Index Hex")

    menu.OpenMenu()
    
    int hexToInt = 0
    int intToHex = 1
    int formIDToHex = 2
    int formToHex = 3
    int hexToForm = 4
    int hexToModName = 5
    int formToModName = 6
    int isLightMod = 7
    int isLightModHex = 8
    int isLightModForm = 9
    int hexToModIndex = 10
    int hexToModIndexHex = 11
    int formToModIndex = 12
    int formToModIndexHex = 13

    int selected = menu.GetResultInt()

    string text = GetUserText()

    if selected == hexToInt
        Debug.MessageBox(text + " equals " + FormHelper.HexToInt(text))

    elseIf selected == intToHex
        Debug.MessageBox(text + " equals " + FormHelper.IntToHex(text as int))

    elseIf selected == formIDToHex

    elseIf selected == formToHex

    elseIf selected == hexToForm
        Form aForm = FormHelper.HexToForm(text)
        Debug.MessageBox(text + " equals " + aForm + " " + aForm.GetName())

    elseIf selected == hexToModName
        Debug.MessageBox(text + " comes from mod " + FormHelper.HexToModName(text))

    elseIf selected == formToModName
        Form aForm = FormHelper.HexToForm(text)
        Debug.MessageBox(aForm + " " + aForm.GetName() + " comes from mod " + FormHelper.FormToModName(aForm))

    elseIf selected == isLightMod
        Debug.MessageBox(text + " is a light mod? " + FormHelper.IsLightMod(text))

    elseIf selected == isLightModHex


    elseIf selected == isLightModForm

    elseIf selected == hexToModIndex

    elseIf selected == hexToModIndexHex

    elseIf selected == formToModIndex

    elseIf selected == formToModIndexHex

    endIf
endFunction

Form function GetForm()
    return FormHelper.HexToForm(GetUserText())
endFunction

string function GetUserText()
    UITextEntryMenu menu = UIExtensions.GetMenu("UITextEntryMenu") as UITextEntryMenu
    menu.OpenMenu()
    return menu.GetResultString()
endFunction
