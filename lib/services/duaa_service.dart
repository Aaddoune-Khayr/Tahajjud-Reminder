import 'package:khayr__tahajjud_reminder/models/duaa_model.dart';

class DuaaService {
  static List<DuaaModel> getAllDuaas() => [
        DuaaModel(
          id: '1',
          titleFr: 'Invocation du ProphÃ¨te ï·º durant Tahajjud',
          titleEn: 'Invocation of the Prophet ï·º during Tahajjud',
          titleAr: 'Ø¯Ø¹Ø§Ø¡ Ø§Ù„Ù†Ø¨ÙŠ ï·º ÙÙŠ Ø§Ù„ØªÙ‡Ø¬Ø¯',
          arabic:
              'Ø§Ù„Ù„ÙŽÙ‘Ù‡ÙÙ…ÙŽÙ‘ Ù„ÙŽÙƒÙŽ Ø§Ù„Ù’Ø­ÙŽÙ…Ù’Ø¯Ù Ø£ÙŽÙ†Ù’ØªÙŽ Ù‚ÙŽÙŠÙÙ‘Ù…Ù Ø§Ù„Ø³ÙŽÙ‘Ù…ÙŽØ§ÙˆÙŽØ§ØªÙ ÙˆÙŽØ§Ù„Ù’Ø£ÙŽØ±Ù’Ø¶Ù ÙˆÙŽÙ…ÙŽÙ†Ù’ ÙÙÙŠÙ‡ÙÙ†ÙŽÙ‘ØŒ ÙˆÙŽÙ„ÙŽÙƒÙŽ Ø§Ù„Ù’Ø­ÙŽÙ…Ù’Ø¯Ù Ø£ÙŽÙ†Ù’ØªÙŽ Ù†ÙÙˆØ±Ù Ø§Ù„Ø³ÙŽÙ‘Ù…ÙŽØ§ÙˆÙŽØ§ØªÙ ÙˆÙŽØ§Ù„Ù’Ø£ÙŽØ±Ù’Ø¶Ù ÙˆÙŽÙ…ÙŽÙ†Ù’ ÙÙÙŠÙ‡ÙÙ†ÙŽÙ‘ØŒ ÙˆÙŽÙ„ÙŽÙƒÙŽ Ø§Ù„Ù’Ø­ÙŽÙ…Ù’Ø¯Ù Ø£ÙŽÙ†Ù’ØªÙŽ Ù…ÙŽÙ„ÙÙƒÙ Ø§Ù„Ø³ÙŽÙ‘Ù…ÙŽØ§ÙˆÙŽØ§ØªÙ ÙˆÙŽØ§Ù„Ù’Ø£ÙŽØ±Ù’Ø¶Ù ÙˆÙŽÙ…ÙŽÙ†Ù’ ÙÙÙŠÙ‡ÙÙ†ÙŽÙ‘ØŒ ÙˆÙŽÙ„ÙŽÙƒÙŽ Ø§Ù„Ù’Ø­ÙŽÙ…Ù’Ø¯Ù Ø£ÙŽÙ†Ù’ØªÙŽ Ø§Ù„Ù’Ø­ÙŽÙ‚ÙÙ‘ØŒ ÙˆÙŽÙˆÙŽØ¹Ù’Ø¯ÙÙƒÙŽ Ø§Ù„Ù’Ø­ÙŽÙ‚ÙÙ‘ØŒ ÙˆÙŽÙ„ÙÙ‚ÙŽØ§Ø¤ÙÙƒÙŽ Ø­ÙŽÙ‚ÙŒÙ‘ØŒ ÙˆÙŽÙ‚ÙŽÙˆÙ’Ù„ÙÙƒÙŽ Ø­ÙŽÙ‚ÙŒÙ‘ØŒ ÙˆÙŽØ§Ù„Ù’Ø¬ÙŽÙ†ÙŽÙ‘Ø©Ù Ø­ÙŽÙ‚ÙŒÙ‘ØŒ ÙˆÙŽØ§Ù„Ù†ÙŽÙ‘Ø§Ø±Ù Ø­ÙŽÙ‚ÙŒÙ‘ØŒ ÙˆÙŽØ§Ù„Ù†ÙŽÙ‘Ø¨ÙÙŠÙÙ‘ÙˆÙ†ÙŽ Ø­ÙŽÙ‚ÙŒÙ‘ØŒ ÙˆÙŽÙ…ÙØ­ÙŽÙ…ÙŽÙ‘Ø¯ÙŒ Ø­ÙŽÙ‚ÙŒÙ‘ØŒ ÙˆÙŽØ§Ù„Ø³ÙŽÙ‘Ø§Ø¹ÙŽØ©Ù Ø­ÙŽÙ‚ÙŒÙ‘ØŒ Ø§Ù„Ù„ÙŽÙ‘Ù‡ÙÙ…ÙŽÙ‘ Ù„ÙŽÙƒÙŽ Ø£ÙŽØ³Ù’Ù„ÙŽÙ…Ù’ØªÙØŒ ÙˆÙŽØ¨ÙÙƒÙŽ Ø¢Ù…ÙŽÙ†Ù’ØªÙØŒ ÙˆÙŽØ¹ÙŽÙ„ÙŽÙŠÙ’ÙƒÙŽ ØªÙŽÙˆÙŽÙƒÙŽÙ‘Ù„Ù’ØªÙØŒ ÙˆÙŽØ¥ÙÙ„ÙŽÙŠÙ’ÙƒÙŽ Ø£ÙŽÙ†ÙŽØ¨Ù’ØªÙØŒ ÙˆÙŽØ¨ÙÙƒÙŽ Ø®ÙŽØ§ØµÙŽÙ…Ù’ØªÙØŒ ÙˆÙŽØ¥ÙÙ„ÙŽÙŠÙ’ÙƒÙŽ Ø­ÙŽØ§ÙƒÙŽÙ…Ù’ØªÙØŒ ÙÙŽØ§ØºÙ’ÙÙØ±Ù’ Ù„ÙÙŠ Ù…ÙŽØ§ Ù‚ÙŽØ¯ÙŽÙ‘Ù…Ù’ØªÙ ÙˆÙŽÙ…ÙŽØ§ Ø£ÙŽØ®ÙŽÙ‘Ø±Ù’ØªÙØŒ ÙˆÙŽÙ…ÙŽØ§ Ø£ÙŽØ³Ù’Ø±ÙŽØ±Ù’ØªÙ ÙˆÙŽÙ…ÙŽØ§ Ø£ÙŽØ¹Ù’Ù„ÙŽÙ†Ù’ØªÙØŒ Ø£ÙŽÙ†Ù’ØªÙŽ Ø§Ù„Ù’Ù…ÙÙ‚ÙŽØ¯ÙÙ‘Ù…Ù ÙˆÙŽØ£ÙŽÙ†Ù’ØªÙŽ Ø§Ù„Ù’Ù…ÙØ¤ÙŽØ®ÙÙ‘Ø±ÙØŒ Ù„ÙŽØ§ Ø¥ÙÙ„ÙŽÙ‡ÙŽ Ø¥ÙÙ„ÙŽÙ‘Ø§ Ø£ÙŽÙ†Ù’ØªÙŽ',
          translationFr:
              'Ã” Allah, Ã  Toi la louange, Tu es le Mainteneur des cieux et de la terre et de ceux qui s\'y trouvent. Ã€ Toi la louange, Tu es la LumiÃ¨re des cieux et de la terre et de ceux qui s\'y trouvent. Ã€ Toi la louange, Tu es le Roi des cieux et de la terre et de ceux qui s\'y trouvent. Ã€ Toi la louange, Tu es la VÃ©ritÃ©, Ta promesse est vÃ©ritÃ©, Ta rencontre est vÃ©ritÃ©, Ta parole est vÃ©ritÃ©, le Paradis est vÃ©ritÃ©, l\'Enfer est vÃ©ritÃ©, les ProphÃ¨tes sont vÃ©ritÃ©, Muhammad est vÃ©ritÃ©, et l\'Heure est vÃ©ritÃ©. Ã” Allah, Ã  Toi je me suis soumis, en Toi j\'ai cru, sur Toi je me suis appuyÃ©, vers Toi je me suis repenti, par Toi j\'ai combattu, et Ã  Toi j\'ai eu recours pour juger. Pardonne-moi donc ce que j\'ai fait et ce que je ferai, ce que j\'ai cachÃ© et ce que j\'ai montrÃ©. Tu es Celui qui avance et Celui qui retarde. Il n\'y a de divinitÃ© digne d\'adoration que Toi.',
          translationEn:
              'O Allah, to You belongs all praise. You are the Maintainer of the heavens and the earth and all that is in them. To You belongs all praise. You are the Light of the heavens and the earth and all that is in them. To You belongs all praise. You are the King of the heavens and the earth and all that is in them. To You belongs all praise. You are the Truth, Your promise is truth, meeting You is truth, Your word is truth, Paradise is truth, Hell is truth, the Prophets are truth, Muhammad is truth, and the Hour is truth. O Allah, to You I have submitted, in You I have believed, upon You I have relied, to You I have turned, with You I have argued, and to You I have resorted for judgment. So forgive me what I have sent forth and what I have left behind, what I have concealed and what I have declared. You are the One who sends forth and the One who delays. There is no deity worthy of worship except You.',
          source: 'Sahih Muslim',
        ),
        DuaaModel(
          id: '2',
          titleFr: 'Du\'aa en se levant pour la priÃ¨re de nuit',
          titleEn: 'Du\'aa when rising for night prayer',
          titleAr: 'Ø¯Ø¹Ø§Ø¡ Ø§Ù„Ù‚ÙŠØ§Ù… Ù…Ù† Ø§Ù„Ù„ÙŠÙ„',
          arabic:
              'Ø§Ù„Ù„ÙŽÙ‘Ù‡ÙÙ…ÙŽÙ‘ Ø±ÙŽØ¨ÙŽÙ‘ Ø¬ÙØ¨Ù’Ø±ÙÙŠÙ„ÙŽ ÙˆÙŽÙ…ÙÙŠÙƒÙŽØ§Ø¦ÙÙŠÙ„ÙŽ ÙˆÙŽØ¥ÙØ³Ù’Ø±ÙŽØ§ÙÙÙŠÙ„ÙŽØŒ ÙÙŽØ§Ø·ÙØ±ÙŽ Ø§Ù„Ø³ÙŽÙ‘Ù…ÙŽØ§ÙˆÙŽØ§ØªÙ ÙˆÙŽØ§Ù„Ù’Ø£ÙŽØ±Ù’Ø¶ÙØŒ Ø¹ÙŽØ§Ù„ÙÙ…ÙŽ Ø§Ù„Ù’ØºÙŽÙŠÙ’Ø¨Ù ÙˆÙŽØ§Ù„Ø´ÙŽÙ‘Ù‡ÙŽØ§Ø¯ÙŽØ©ÙØŒ Ø£ÙŽÙ†Ù’ØªÙŽ ØªÙŽØ­Ù’ÙƒÙÙ…Ù Ø¨ÙŽÙŠÙ’Ù†ÙŽ Ø¹ÙØ¨ÙŽØ§Ø¯ÙÙƒÙŽ ÙÙÙŠÙ…ÙŽØ§ ÙƒÙŽØ§Ù†ÙÙˆØ§ ÙÙÙŠÙ‡Ù ÙŠÙŽØ®Ù’ØªÙŽÙ„ÙÙÙÙˆÙ†ÙŽØŒ Ø§Ù‡Ù’Ø¯ÙÙ†ÙÙŠ Ù„ÙÙ…ÙŽØ§ Ø§Ø®Ù’ØªÙÙ„ÙÙÙŽ ÙÙÙŠÙ‡Ù Ù…ÙÙ†ÙŽ Ø§Ù„Ù’Ø­ÙŽÙ‚ÙÙ‘ Ø¨ÙØ¥ÙØ°Ù’Ù†ÙÙƒÙŽØŒ Ø¥ÙÙ†ÙŽÙ‘ÙƒÙŽ ØªÙŽÙ‡Ù’Ø¯ÙÙŠ Ù…ÙŽÙ†Ù’ ØªÙŽØ´ÙŽØ§Ø¡Ù Ø¥ÙÙ„ÙŽÙ‰ ØµÙØ±ÙŽØ§Ø·Ù Ù…ÙØ³Ù’ØªÙŽÙ‚ÙÙŠÙ…Ù',
          translationFr:
              'Ã” Allah, Seigneur de JibrÃ®l, MikÃ¢\'Ã®l et IsrÃ¢fÃ®l, CrÃ©ateur des cieux et de la terre, Connaisseur de l\'invisible et du visible, Tu juges entre Tes serviteurs dans ce sur quoi ils divergent. Guide-moi vers la vÃ©ritÃ© dans ce sur quoi les gens divergent, par Ta permission. Certes, Tu guides qui Tu veux vers un chemin droit.',
          translationEn:
              'O Allah, Lord of Jibreel, Mikaeel and Israfil, Creator of the heavens and the earth, Knower of the unseen and the seen, You judge between Your servants concerning that wherein they differ. Guide me to the truth concerning that wherein they differ, by Your permission. Indeed, You guide whom You will to a straight path.',
          source: 'Sahih Muslim',
        ),
        DuaaModel(
          id: '3',
          titleFr: 'Du\'aa puissant pour le pardon',
          titleEn: 'Powerful du\'aa for forgiveness',
          titleAr: 'Ø¯Ø¹Ø§Ø¡ Ø¹Ø¸ÙŠÙ… Ù„Ù„Ù…ØºÙØ±Ø©',
          arabic:
              'Ø§Ù„Ù„ÙŽÙ‘Ù‡ÙÙ…ÙŽÙ‘ Ø§ØºÙ’ÙÙØ±Ù’ Ù„ÙÙŠ Ø°ÙŽÙ†Ù’Ø¨ÙÙŠ ÙƒÙÙ„ÙŽÙ‘Ù‡ÙØŒ Ø¯ÙÙ‚ÙŽÙ‘Ù‡Ù ÙˆÙŽØ¬ÙÙ„ÙŽÙ‘Ù‡ÙØŒ ÙˆÙŽØ£ÙŽÙˆÙŽÙ‘Ù„ÙŽÙ‡Ù ÙˆÙŽØ¢Ø®ÙØ±ÙŽÙ‡ÙØŒ ÙˆÙŽØ¹ÙŽÙ„ÙŽØ§Ù†ÙÙŠÙŽØªÙŽÙ‡Ù ÙˆÙŽØ³ÙØ±ÙŽÙ‘Ù‡Ù',
          translationFr:
              'Ã” Allah, pardonne-moi tous mes pÃ©chÃ©s : les petits et les grands, les premiers et les derniers, les apparents et les cachÃ©s.',
          translationEn:
              'O Allah, forgive me all my sins: the small and the great, the first and the last, the apparent and the hidden.',
          source: 'Sahih Muslim',
        ),
        DuaaModel(
          id: '4',
          titleFr: 'Invocation simple utilisÃ©e la nuit',
          titleEn: 'Simple invocation used at night',
          titleAr: 'Ø¯Ø¹Ø§Ø¡ Ø¨Ø³ÙŠØ· ÙŠÙØ³ØªØ¹Ù…Ù„ ÙÙŠ Ø§Ù„Ù„ÙŠÙ„',
          arabic:
              'Ø§Ù„Ù„ÙŽÙ‘Ù‡ÙÙ…ÙŽÙ‘ Ø§ØºÙ’ÙÙØ±Ù’ Ù„ÙÙŠ ÙˆÙŽØ§Ø±Ù’Ø­ÙŽÙ…Ù’Ù†ÙÙŠ ÙˆÙŽØ§Ù‡Ù’Ø¯ÙÙ†ÙÙŠ ÙˆÙŽØ§Ø±Ù’Ø²ÙÙ‚Ù’Ù†ÙÙŠ ÙˆÙŽØ¹ÙŽØ§ÙÙÙ†ÙÙŠ',
          translationFr:
              'Ã” Allah, pardonne-moi, fais-moi misÃ©ricorde, guide-moi, accorde-moi subsistance et santÃ©.',
          translationEn:
              'O Allah, forgive me, have mercy on me, guide me, grant me provision, and grant me good health.',
          source: 'Sahih Muslim',
        ),
        DuaaModel(
          id: '5',
          titleFr: 'Du\'aa de Salat al-Istikhara',
          titleEn: 'Du\'aa of Salat al-Istikhara',
          titleAr: 'Ø¯Ø¹Ø§Ø¡ ØµÙ„Ø§Ø© Ø§Ù„Ø§Ø³ØªØ®Ø§Ø±Ø©',
          arabic:
              'Ø§Ù„Ù„ÙŽÙ‘Ù‡ÙÙ…ÙŽÙ‘ Ø¥ÙÙ†ÙÙ‘ÙŠ Ø£ÙŽØ³Ù’ØªÙŽØ®ÙÙŠØ±ÙÙƒÙŽ Ø¨ÙØ¹ÙÙ„Ù’Ù…ÙÙƒÙŽØŒ ÙˆÙŽØ£ÙŽØ³Ù’ØªÙŽÙ‚Ù’Ø¯ÙØ±ÙÙƒÙŽ Ø¨ÙÙ‚ÙØ¯Ù’Ø±ÙŽØªÙÙƒÙŽØŒ ÙˆÙŽØ£ÙŽØ³Ù’Ø£ÙŽÙ„ÙÙƒÙŽ Ù…ÙÙ†Ù’ ÙÙŽØ¶Ù’Ù„ÙÙƒÙŽ Ø§Ù„Ù’Ø¹ÙŽØ¸ÙÙŠÙ…ÙØŒ ÙÙŽØ¥ÙÙ†ÙŽÙ‘ÙƒÙŽ ØªÙŽÙ‚Ù’Ø¯ÙØ±Ù ÙˆÙŽÙ„ÙŽØ§ Ø£ÙŽÙ‚Ù’Ø¯ÙØ±ÙØŒ ÙˆÙŽØªÙŽØ¹Ù’Ù„ÙŽÙ…Ù ÙˆÙŽÙ„ÙŽØ§ Ø£ÙŽØ¹Ù’Ù„ÙŽÙ…ÙØŒ ÙˆÙŽØ£ÙŽÙ†Ù’ØªÙŽ Ø¹ÙŽÙ„ÙŽÙ‘Ø§Ù…Ù Ø§Ù„Ù’ØºÙÙŠÙÙˆØ¨ÙØŒ Ø§Ù„Ù„ÙŽÙ‘Ù‡ÙÙ…ÙŽÙ‘ Ø¥ÙÙ†Ù’ ÙƒÙÙ†Ù’ØªÙŽ ØªÙŽØ¹Ù’Ù„ÙŽÙ…Ù Ø£ÙŽÙ†ÙŽÙ‘ Ù‡ÙŽØ°ÙŽØ§ Ø§Ù„Ù’Ø£ÙŽÙ…Ù’Ø±ÙŽ Ø®ÙŽÙŠÙ’Ø±ÙŒ Ù„ÙÙŠ ÙÙÙŠ Ø¯ÙÙŠÙ†ÙÙŠ ÙˆÙŽÙ…ÙŽØ¹ÙŽØ§Ø´ÙÙŠ ÙˆÙŽØ¹ÙŽØ§Ù‚ÙØ¨ÙŽØ©Ù Ø£ÙŽÙ…Ù’Ø±ÙÙŠ ÙÙŽØ§Ù‚Ù’Ø¯ÙØ±Ù’Ù‡Ù Ù„ÙÙŠ ÙˆÙŽÙŠÙŽØ³ÙÙ‘Ø±Ù’Ù‡Ù Ù„ÙÙŠ Ø«ÙÙ…ÙŽÙ‘ Ø¨ÙŽØ§Ø±ÙÙƒÙ’ Ù„ÙÙŠ ÙÙÙŠÙ‡ÙØŒ ÙˆÙŽØ¥ÙÙ†Ù’ ÙƒÙÙ†Ù’ØªÙŽ ØªÙŽØ¹Ù’Ù„ÙŽÙ…Ù Ø£ÙŽÙ†ÙŽÙ‘ Ù‡ÙŽØ°ÙŽØ§ Ø§Ù„Ù’Ø£ÙŽÙ…Ù’Ø±ÙŽ Ø´ÙŽØ±ÙŒÙ‘ Ù„ÙÙŠ ÙÙÙŠ Ø¯ÙÙŠÙ†ÙÙŠ ÙˆÙŽÙ…ÙŽØ¹ÙŽØ§Ø´ÙÙŠ ÙˆÙŽØ¹ÙŽØ§Ù‚ÙØ¨ÙŽØ©Ù Ø£ÙŽÙ…Ù’Ø±ÙÙŠ ÙÙŽØ§ØµÙ’Ø±ÙÙÙ’Ù‡Ù Ø¹ÙŽÙ†ÙÙ‘ÙŠ ÙˆÙŽØ§ØµÙ’Ø±ÙÙÙ’Ù†ÙÙŠ Ø¹ÙŽÙ†Ù’Ù‡ÙØŒ ÙˆÙŽØ§Ù‚Ù’Ø¯ÙØ±Ù’ Ù„ÙÙŠÙŽ Ø§Ù„Ù’Ø®ÙŽÙŠÙ’Ø±ÙŽ Ø­ÙŽÙŠÙ’Ø«Ù ÙƒÙŽØ§Ù†ÙŽ Ø«ÙÙ…ÙŽÙ‘ Ø£ÙŽØ±Ù’Ø¶ÙÙ†ÙÙŠ Ø¨ÙÙ‡Ù',
          translationFr:
              'Ã” Allah, je Te consulte par Ta connaissance, je Te demande de m\'accorder la capacitÃ© par Ton pouvoir, et je Te demande de Ton immense gÃ©nÃ©rositÃ©. Car Tu es capable et je ne le suis pas, Tu sais et je ne sais pas, et Tu es le Grand Connaisseur de l\'invisible. Ã” Allah, si Tu sais que cette affaire est bonne pour moi dans ma religion, ma vie et mon devenir, alors dÃ©crÃ¨te-la moi, facilite-la moi, puis bÃ©nis-la pour moi. Et si Tu sais que cette affaire est mauvaise pour moi dans ma religion, ma vie et mon devenir, alors dÃ©tourne-la de moi et dÃ©tourne-moi d\'elle, et dÃ©crÃ¨te-moi le bien oÃ¹ qu\'il soit, puis rends-moi satisfait de cela.',
          translationEn:
              'O Allah, I seek Your counsel through Your knowledge, and I seek strength through Your power, and I ask You from Your immense favor. For indeed, You have power and I have none, and You know and I know not, and You are the Knower of the unseen. O Allah, if You know that this matter is good for me in my religion, my livelihood, and the outcome of my affairs, then decree it for me and make it easy for me, and then bless me in it. And if You know that this matter is bad for me in my religion, my livelihood, and the outcome of my affairs, then turn it away from me and turn me away from it, and decree for me what is good wherever it may be, and then make me pleased with it.',
          source: 'Sahih al-Bukhari',
        ),
      ];
}