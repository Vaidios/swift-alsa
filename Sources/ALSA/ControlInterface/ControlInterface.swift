import CALSA

public struct SoundCard {
    public let id: String
    public let name: String
}

final class ControlInterface {

// First the control interface has to be opened using snd_ctl_open(InterfaceName)

    public func getSoundCards() -> [SoundCard] {
        var cardList: [SoundCard] = []
        var card: Int32 = -1

        while snd_card_next(&card) >= 0 && card >= 0 {
            var cardInfoPtr: OpaquePointer?
            snd_ctl_card_info_malloc(&cardInfoPtr)

            if let cardInfoPtr = cardInfoPtr {
                defer { snd_ctl_card_info_free(cardInfoPtr) }
                var ctlPtr: OpaquePointer?
                var name: UnsafePointer<Int8>? = snd_ctl_card_info_get_id(cardInfoPtr)
                let cardName = "hw:\(card)"

                if snd_ctl_open(&ctlPtr, cardName, 0) >= 0,
                   let ctlPtr = ctlPtr {
                    defer { snd_ctl_close(ctlPtr) }

                    if snd_ctl_card_info(ctlPtr, cardInfoPtr) >= 0,
                       let id = String(cString: snd_ctl_card_info_get_id(cardInfoPtr), encoding: .utf8),
                       let name = String(cString: snd_ctl_card_info_get_name(cardInfoPtr), encoding: .utf8) {
                        let cardInfo = SoundCard(id: id, name: name)
                        cardList.append(cardInfo)
                    }
                }
            }
        }

        return cardList
    }
}