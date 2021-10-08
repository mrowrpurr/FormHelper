scriptName FormIds_UI_Effect extends ActiveMagicEffect  

event OnEffectStart(Actor target, Actor caster)
    FormIds_UI.GetInstance().ShowUI()
endEvent
