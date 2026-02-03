import 'package:khayr__tahajjud_reminder/models/duaa_model.dart';

class DuaaService {
  static List<DuaaModel> getAllDuaas() => [
        DuaaModel(
          id: '1',
          titleFr: 'Invocation du Prophète ﷺ durant le Tahajjud',
          titleEn: 'Invocation of the Prophet ﷺ during Tahajjud',
          titleAr: 'دُعَاءُ النَّبِيِّ ﷺ فِي التَّهَجُّدِ',
          arabic:
              'اللهم لك الحمد، أنت قيِّم السماوات والأرض ومن فيهن، ولك الحمد، أنت نور السماوات والأرض ومن فيهن، ولك الحمد، أنت ملك السماوات والأرض ومن فيهن، ولك الحمد، أنت الحق، ووعدك الحق، ولقاؤك حق، وقولك حق، والجنة حق، والنار حق، والنبيون حق، ومحمد حق، والساعة حق. اللهم لك أسلمت، وبك آمنت، وعليك توكلت، وإليك أنبت، وبك خاصمت، وإليك حاكمت، فاغفر لي ما قدمت وما أخرت، وما أسررت وما أعلنت، أنت المقدم وأنت المؤخر، لا إله إلا أنت.',
          translationFr:
              'Ô Allah, à Toi la louange, Tu es le Mainteneur des cieux et de la terre et de ceux qui s’y trouvent. À Toi la louange, Tu es la Lumière des cieux et de la terre et de ceux qui s’y trouvent. À Toi la louange, Tu es le Roi des cieux et de la terre et de ceux qui s’y trouvent. À Toi la louange, Tu es la Vérité, Ta promesse est vérité, Ta rencontre est vérité, Ta parole est vérité, le Paradis est vérité, l’Enfer est vérité, les Prophètes sont vérité, Muhammad est vérité, et l’Heure est vérité. Ô Allah, à Toi je me suis soumis, en Toi j’ai cru, sur Toi je me suis appuyé, vers Toi je me suis repenti, par Toi j’ai combattu, et à Toi j’ai eu recours pour juger. Pardonne-moi donc ce que j’ai fait et ce que je ferai, ce que j’ai caché et ce que j’ai montré. Tu es Celui qui avance et Celui qui retarde. Il n’y a de divinité digne d’adoration que Toi.',
          translationEn:
              'O Allah, to You belongs all praise. You are the Maintainer of the heavens and the earth and all that is in them. To You belongs all praise. You are the Light of the heavens and the earth and all that is in them. To You belongs all praise. You are the King of the heavens and the earth and all that is in them. To You belongs all praise. You are the Truth, Your promise is truth, meeting You is truth, Your word is truth, Paradise is truth, Hell is truth, the Prophets are truth, Muhammad is truth, and the Hour is truth. O Allah, to You I have submitted, in You I have believed, upon You I have relied, to You I have turned, with You I have argued, and to You I have resorted for judgment. So forgive me what I have sent forth and what I have left behind, what I have concealed and what I have declared. You are the One who sends forth and the One who delays. There is no deity worthy of worship except You.',
          source: 'Sahih Muslim',
        ),
        DuaaModel(
          id: '2',
          titleFr: 'Du\'aa en se levant pour la prière de nuit',
          titleEn: 'Du\'aa when rising for night prayer',
          titleAr: 'دُعَاءُ الْقِيَامِ مِنَ اللَّيْلِ',
          arabic:
              'اللهم رب جبريل وميكائيل وإسرافيل، فاطر السماوات والأرض، عالم الغيب والشهادة، أنت تحكم بين عبادك فيما كانوا فيه يختلفون، اهدني لما اختُلِفَ فيه من الحق بإذنك، إنك تهدي من تشاء إلى صراط مستقيم.',
          translationFr:
              'Ô Allah, Seigneur de Jibrîl, Mikâ’îl et Isrâfîl, Créateur des cieux et de la terre, Connaisseur de l’invisible et du visible, Tu juges entre Tes serviteurs dans ce sur quoi ils divergent. Guide-moi vers la vérité dans ce sur quoi les gens divergent, par Ta permission. Certes, Tu guides qui Tu veux vers un chemin droit.',
          translationEn:
              'O Allah, Lord of Jibreel, Mikaeel and Israfil, Creator of the heavens and the earth, Knower of the unseen and the seen, You judge between Your servants concerning that wherein they differ. Guide me to the truth concerning that wherein they differ, by Your permission. Indeed, You guide whom You will to a straight path.',
          source: 'Sahih Muslim',
        ),
        DuaaModel(
          id: '3',
          titleFr: 'Du\'aa puissant pour le pardon',
          titleEn: 'Powerful du\'aa for forgiveness',
          titleAr: 'دُعَاءٌ عَظِيمٌ لِلْمَغْفِرَةِ',
          arabic:
              'اللهم اغفر لي ذنبي كله، دِقَّه وجِلَّه، وأوَّله وآخره، وعلانيته وسره.',
          translationFr:
              'Ô Allah, pardonne-moi tous mes péchés : les petits et les grands, les premiers et les derniers, les apparents et les cachés.',
          translationEn:
              'O Allah, forgive me all my sins: the small and the great, the first and the last, the apparent and the hidden.',
          source: 'Sahih Muslim',
        ),
        DuaaModel(
          id: '4',
          titleFr: 'Invocation simple utilisée la nuit',
          titleEn: 'Simple invocation used at night',
          titleAr: 'دُعَاءٌ بَسِيطٌ يُسْتَعْمَلُ فِي اللَّيْلِ',
          arabic:
              'اللهم اغفر لي، وارحمني، واهدني، وارزقني، وعافني.',
          translationFr:
              'Ô Allah, pardonne-moi, fais-moi miséricorde, guide-moi, accorde-moi subsistance et santé.',
          translationEn:
              'O Allah, forgive me, have mercy on me, guide me, grant me provision, and grant me good health.',
          source: 'Sahih Muslim',
        ),
        DuaaModel(
          id: '5',
          titleFr: 'Du\'aa de Salat al-Istikhara',
          titleEn: 'Du\'aa of Salat al-Istikhara',
          titleAr: 'دُعَاءُ صَلَاةِ الاِسْتِخَارَةِ',
          arabic:
              'اللهم إني أستخيرك بعلمك، وأستقدرك بقدرتك، وأسألك من فضلك العظيم، فإنك تقدر ولا أقدر، وتعلم ولا أعلم، وأنت علام الغيوب. اللهم إن كنت تعلم أن هذا الأمر خيرٌ لي في ديني ومعاشي وعاقبة أمري، فاقدره لي ويسره لي ثم بارك لي فيه، وإن كنت تعلم أن هذا الأمر شرٌّ لي في ديني ومعاشي وعاقبة أمري، فاصرفه عني واصرفني عنه، واقدر لي الخير حيث كان ثم أرضني به.',
          translationFr:
              'Ô Allah, je Te consulte par Ta science, je Te demande de me donner la capacité par Ta puissance, et je Te demande de Ta grande faveur. Car Tu peux et je ne peux pas, Tu sais et je ne sais pas, et Tu es le Grand Connaisseur de l’invisible. Ô Allah, si Tu sais que cette affaire est bonne pour moi dans ma religion, ma vie présente et la fin de mon affaire, alors décrète-la pour moi, facilite-la moi, puis bénis-la pour moi. Et si Tu sais que cette affaire est mauvaise pour moi dans ma religion, ma vie présente et la fin de mon affaire, alors détourne-la de moi et détourne-moi d’elle, et décrète pour moi le bien où qu’il soit, puis rends-moi satisfait de cela.',
          translationEn:
              'O Allah, I seek Your counsel through Your knowledge, and I seek strength through Your power, and I ask You from Your immense favor. For indeed, You have power and I have none, and You know and I know not, and You are the Knower of the unseen. O Allah, if You know that this matter is good for me in my religion, my livelihood, and the outcome of my affairs, then decree it for me and make it easy for me, and then bless me in it. And if You know that this matter is bad for me in my religion, my livelihood, and the outcome of my affairs, then turn it away from me and turn me away from it, and decree for me what is good wherever it may be, and then make me pleased with it.',
          source: 'Sahih al-Bukhari',
        ),
      ];
}