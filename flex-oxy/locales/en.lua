local Translations = {
    error = {
        nopolice = 'Hmm, there needs to be %{value} police..',
        nobeer = 'Brother, you joking? You dont have the right item..',
        mad = 'Go away!',
        alreadystarted = 'You already doing a task for me, come back later..',
        nooxy = 'HEY! You dont have my order..',
        topoor = 'Rip, you are to poor..',
        idkyou = 'And you are?',
    },
    success = {
        checkgps = 'Check your GPS for a location..',
        thanks = 'Perfect, thanks!',
        buy = 'Thanks for your order',
        nothingnew = 'Dont have anythng new atm..',
    },
    target = {
        talktoped = 'Talk to person..',
        delivertoped = 'Give Oxy..',
    },
    deliverinfo = {
        blipname = 'Client',
    },
    menu = {
        header = 'This guy any wants to talk if you have the right item..',
        yes = 'Give him the item',
        no = 'Give him the item',
        shop = 'Look what he has to offer',
        stock = '%{value} in stock',
    },
    command = {
        levelcommand = 'Show your oxy level',
        showstorelevel = 'You have %{value}/%{value2} oxylevel',
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
