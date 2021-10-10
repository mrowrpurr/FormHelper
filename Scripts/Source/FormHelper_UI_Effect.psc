scriptName FormHelper_UI_Effect extends ActiveMagicEffect  

event OnEffectStart(Actor target, Actor caster)
    FormHelper_UI.GetInstance().ShowUI()
endEvent
