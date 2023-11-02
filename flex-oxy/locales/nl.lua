local Translations = {
    error = {
        nopolice = 'Aii, der moet %{value} politie int stad zijn..',
        nobeer = 'MoAtJe, Je HeBt GEeEeNn HEInike VoOr MiJ..',
        mad = 'FoKk OfF',
        alreadystarted = 'Je hebt al een klant, kom later terug..',
        nooxy = 'ELA, je hebt mijn bestelling niet..',
        topoor = 'AII, je bent te skeer..',
        idkyou = 'En jij bent?',
    },
    success = {
        checkgps = 'KhEb U LoCa GeGevee op G PS',
        thanks = 'Ahn perfect, dankuwel!',
        buy = 'Fijn zaken te doen',
        nothingnew = 'Kheb voorlopig niks nieuws meer in aanbieding..',
    },
    target = {
        talktoped = 'Praat met meneer..',
        delivertoped = 'Geef Oxy..',
    },
    deliverinfo = {
        blipname = 'Klant',
    },
    menu = {
        header = 'De man wilt alleen praten als je hem bier geeft..',
        yes = 'Geef hem bier',
        no = 'Geef hem geen bier',
        shop = 'Bekijk wat die te bieden heeft',
        stock = '%{value} in stock',
    },
    command = {
        levelcommand = 'Toon je oxywinkel level',
        showstorelevel = 'Je zit op %{value}/%{value2} van de oxywinkel',
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
