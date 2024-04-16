Config = {}
Translation = {}

Config.Locale = 'en'

Config.Currency = '$'
Config.WeightUnit = 'kg'

Config.OpenMenu = 289   -- Default: F2 - Keys: https://gist.github.com/KingCprey/d40f6deb8ac2949d95524448596e2f37

Config.useExports = true -- set this to true if you use the new ESX version

Config.HandcuffItem = 'cuffs'   -- if you use an another item name, add the item in your database
Config.HandcuffkeysItem = 'cuff_keys'   -- if you use an another item name, add the item in your database

Config.UnemployedJob = 'unemployed'
Config.DefaultJobGrade = 0

Config.useInventory = true

Config.showPlayeractions = true
Config.PlayeractionsContent = {
    cuff = true,
    searchPlayer = false,   -- coming soon (join discord for updates: https://dsc.gg/primeScripts)
    searchIDCard = true,
}

Config.showWallet = true
Config.WalletContent = {
    playerid = true,
    iban = false,        -- required: primeBanking
    job = true,
    cash = true,
    bank = true,
    blackmoney = true,
    IDCard = true,
    DriverLicense = true,
    GunLicense = true,
}

Config.showCompany = true
Config.GradeAccess = {
    'boss',
    'chief_doctor',
}
Config.CompanyContent = {
    societymoney = true,
    hire = true,
    promote = true,
    degrade = true,
    fire = true,
}

Config.showVehiclemenu = true
Config.VehiclemenuContent = {
    engine = true,
    doorsAndWindows = true,
}

Translation = {
    ['de'] = {
        ['inventorytitle'] = 'Inventar',
        ['inventorySubtitle'] = 'Inventar',
        ['useInventoryItem'] = 'Benutzen',
        ['giveInventoryItem'] = 'Geben',
        ['dropInventoryItem'] = 'Droppen',
        ['notEnoughNotify'] = '~r~Du hast kein ',
        ['notEnoughNotify2'] = ' mehr.',
        ['giveItemDialog'] = 'Wie viel ',
        ['giveItemDialog2'] = ' willst du geben?',
        ['noPlayerFound'] = '~r~Keine Person in der Nähe.',
        ['inputFigureText'] = '~r~Bitte gebe eine Zahl ein.',
        ['dropItemtext1'] = 'Wie viel ',
        ['dropItemtext2'] = ' willst du droppen?',
        ['PlayermenuTitle'] = 'Spielermenu',
        ['PlayermenuSubtitle'] = 'Spielermenu',
        ['PlayeractionsTitle'] = 'Spieleraktionen',
        ['handcuffTitle'] = 'Kabelbinder anlegen',
        ['cutHandcuffs'] = 'Kabelbinder durchschneiden',
        ['showIDCardTitle'] = 'Ausweis anzeigen',
        ['walletTitle'] = 'Brieftasche',
        ['jobTitle'] = 'Beruf: ',
        ['CashTitle'] = 'Bargeld: ',
        ['bankTitle'] = 'Kontostand: ',
        ['IDOptionsSee'] = 'Anschauen',
        ['IDOptionsShow'] = 'Zeigen',
        ['IDCardTitle'] = 'Ausweis',
        ['DriversLicenseTitle'] = 'Führerschein',
        ['WeaponLicenseTitle'] = 'Waffenschein',
        ['SeeIDCardNotify'] = 'Drücke ~g~Backspace~s~, um dein Ausweis auszublenden.',
        ['cuffPlayerNotify'] = '~r~Die Person muss gefesselt sein.',
        ['searchIDCardNotify'] = 'Ausweis suchen..',
        ['weight'] = 'Gewicht: ',
        ['yourid'] = 'Deine ID: ',
        ['iban'] = 'IBAN: ',
        ['noiban'] = 'IBAN: ~t~Keine IBAN',
        ['blackmoney'] = 'Schwarzgeld: ~r~',
        ['company'] = 'Firma',
        ['companylabel'] = 'Firma: ',
        ['business_account'] = 'Geschäftskonto:',
        ['hire_employee'] = 'Mitarbeiter einstellen',
        ['hire_subtitle'] = 'Stelle die Person in deiner Nähe ein.',
        ['promote_employee'] = 'Mitarbeiter befördern',
        ['promote_subtitle'] = 'Befördere den Mitarbeiter in deiner Nähe.',
        ['degrade_employee'] = 'Mitarbeiter degradieren',
        ['degrade_subtitle'] = 'Degradiere den Mitarbeiter in deiner Nähe.',
        ['fire_employee'] = '~r~Mitarbeiter feuern',
        ['fire_subtitle'] = '~r~Feuer den Mitarbeiter~s~ in deiner Nähe.',
        ['company_locked'] = '~t~Firma',
        ['vehiclemenu'] = 'Fahrzeugmenü',
        ['toggle_engine'] = 'Motor an-/ausschalten',
        ['engine_on'] = '~g~An',
        ['engine_off'] = '~r~Aus',
        ['frontleft'] = 'Vorne Links',
        ['frontright'] = 'Vorne Rechts',
        ['backleft'] = 'Hinten Links',
        ['backright'] = 'Hinten Rechts',
        ['trunk'] = 'Kofferraum',
        ['hood'] = 'Motorhaube',
        ['doors'] = 'Türen',
        ['windows'] = 'Fenster',
        ['vehiclemenu_locked'] = '~t~Fahrzeugmenü',
        ['fired_notify'] = '~r~Du wurdest gefeuert!',
        ['youfired_notify1'] = 'Du hast ',
        ['youfired_notify2'] = ' gefeuert.',
        ['error_samejob'] = '~r~Die Person ist nicht bei dir eingestellt.',
        ['degraded'] = 'Du wurdest degradiert.',
        ['youdegraded_notify1'] = 'Du hast ',
        ['youdegraded_notify2'] = ' degradiert.',
        ['promoted'] = 'Du wurdest befördert.',
        ['youpromoted_notify1'] = 'Du hast ',
        ['youpromoted_notify2'] = ' befördert.',
        ['hired1'] = 'Du wurdest bei ',
        ['hired2'] = ' eingestellt.',
        ['youhired_notify1'] = 'Du hast ',
        ['youhired_notify2'] = ' bei deiner Firma eingestellt.',
        ['already_an_employee'] = '~r~Die Person ist schon in deinem Unternehmen eingestellt.',
    },
    ['en'] = {
        ['inventorytitle'] = 'Inventory',
        ['inventorySubtitle'] = 'Inventory',
        ['useInventoryItem'] = 'Use',
        ['giveInventoryItem'] = 'Give',
        ['dropInventoryItem'] = 'Drop',
        ['notEnoughNotify'] = '~r~You do not have ',
        ['notEnoughNotify2'] = ' anymore.',
        ['giveItemDialog'] = 'How much ',
        ['giveItemDialog2'] = ' you want to give?',
        ['noPlayerFound'] = '~r~No players around.',
        ['inputFigureText'] = '~r~Please enter a number.',
        ['dropItemtext1'] = 'How much/many ',
        ['dropItemtext2'] = ' do you want to drop?',
        ['PlayermenuTitle'] = 'Playermenu',
        ['PlayermenuSubtitle'] = 'Playermenu',
        ['PlayeractionsTitle'] = 'Playeractions',
        ['handcuffTitle'] = 'Cuff player',
        ['cutHandcuffs'] = 'Uncuff player',
        ['showIDCardTitle'] = 'Show ID card',
        ['walletTitle'] = 'Wallet',
        ['jobTitle'] = 'Job: ',
        ['CashTitle'] = 'Cash: ',
        ['bankTitle'] = 'Bank: ',
        ['IDOptionsSee'] = 'See',
        ['IDOptionsShow'] = 'Show',
        ['IDCardTitle'] = 'ID Card',
        ['DriversLicenseTitle'] = 'Driver License',
        ['WeaponLicenseTitle'] = 'Weapon License',
        ['SeeIDCardNotify'] = 'Press ~g~Backspace~s~, to hide your ID Card.',
        ['cuffPlayerNotify'] = '~r~The person must be handcuffed.',
        ['searchIDCardNotify'] = 'search ID Card..',
        ['weight'] = 'Weight: ',
        ['yourid'] = 'Your ID: ',
        ['iban'] = 'IBAN: ',
        ['noiban'] = 'IBAN: ~t~No IBAN',
        ['blackmoney'] = 'Blackmoney: ~r~',
        ['company'] = 'Company',
        ['companylabel'] = 'Company: ',
        ['business_account'] = 'Business Account:',
        ['hire_employee'] = 'Hire Employee',
        ['hire_subtitle'] = 'Hire the person closest to you.',
        ['promote_employee'] = 'Promote Employee',
        ['promote_subtitle'] = 'Promote the employee closest to you.',
        ['degrade_employee'] = 'Degrade Employee',
        ['degrade_subtitle'] = 'Degrade the employee closest to you.',
        ['fire_employee'] = '~r~Fire Employee',
        ['fire_subtitle'] = '~r~Fire the employee~s~ closest to you.',
        ['company_locked'] = '~t~Company',
        ['vehiclemenu'] = 'Vehiclemenu',
        ['toggle_engine'] = 'Toggle Engine',
        ['engine_on'] = '~g~On',
        ['engine_off'] = '~r~Off',
        ['frontleft'] = 'Front Left',
        ['frontright'] = 'Front Right',
        ['backleft'] = 'Back Left',
        ['backright'] = 'Back Right',
        ['trunk'] = 'Trunk',
        ['hood'] = 'Hood',
        ['doors'] = 'Doors',
        ['windows'] = 'Windows',
        ['vehiclemenu_locked'] = '~t~Vehiclemenu',
        ['fired_notify'] = '~r~You have been fired!',
        ['youfired_notify1'] = 'You fired ',
        ['youfired_notify2'] = '.',
        ['error_samejob'] = '~r~The person is not employed by you.',
        ['degraded'] = 'You have been demoted.',
        ['youdegraded_notify1'] = 'You have demoted ',
        ['youdegraded_notify2'] = '.',
        ['promoted'] = 'You have been promoted.',
        ['youpromoted_notify1'] = 'You have been promoted ',
        ['youpromoted_notify2'] = '.',
        ['hired1'] = 'You were hired at ',
        ['hired2'] = '.',
        ['youhired_notify1'] = 'You hired ',
        ['youhired_notify2'] = ' at your company.',
        ['already_an_employee'] = '~r~The person is already employed by your company.',
    },
}