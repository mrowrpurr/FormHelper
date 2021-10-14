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
        Form aForm = FormHelper.HexToForm(text)
        Debug.MessageBox(aForm + " " + aForm.GetName() + " equals " + FormHelper.FormIdToHex(aForm.GetFormID()))

    elseIf selected == formToHex
        Form aForm = FormHelper.HexToForm(text)
        Debug.MessageBox(aForm + " " + aForm.GetName() + " equals " + FormHelper.FormToHex(aForm))

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
        Debug.MessageBox(text + " is light mod hex? " + FormHelper.IsLightModHex(text))

    elseIf selected == isLightModForm
        Form aForm = FormHelper.HexToForm(text)
        Debug.MessageBox(aForm + " " + aForm.GetName() + " is light mod form? " + FormHelper.IsLightModForm(aForm))

    elseIf selected == hexToModIndex
        Debug.MessageBox(text + " mod index is " + FormHelper.HexToModIndex(text))

    elseIf selected == hexToModIndexHex
        Debug.MessageBox(text + " mod index hex is " + FormHelper.HexToModIndexHex(text))

    elseIf selected == formToModIndex
        Form aForm = FormHelper.HexToForm(text)
        Debug.MessageBox(aForm + " " + aForm.GetName() + " mod index hex is " + FormHelper.FormToModIndex(aForm))

    elseIf selected == formToModIndexHex
        Form aForm = FormHelper.HexToForm(text)
        Debug.MessageBox(aForm + " " + aForm.GetName() + " mod index hex is " + FormHelper.FormToModIndexHex(aForm))

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
