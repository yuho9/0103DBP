
package com.campusmatching.model.service;

import java.util.concurrent.ThreadLocalRandom;

public class NicknameGenerator {

    private static final String[] ADJECTIVES = {
            "멋진",
            "꼼꼼한",
            "용감한",
            "섬세한",
            "배부른",
            "누워있는",
            "뒹굴거리는",
            "졸린",
            "말랑한",
            "폭신한",
            "반짝이는",
            "수줍은",
            "신나는",
            "느긋한",
            "호기심많은",
            "부지런한",
            "엉뚱한",
            "귀여운",
            "꿈꾸는",
            "따뜻한"
    };

    private static final String[] NOUNS = {
            "솜솜이",
            "동그라미",
            "솜뭉치",
            "솜"
    };

    private NicknameGenerator() {
    }

    public static String generate() {
        ThreadLocalRandom random = ThreadLocalRandom.current();

        String adjective = ADJECTIVES[
                random.nextInt(ADJECTIVES.length)
        ];

        String noun = NOUNS[
                random.nextInt(NOUNS.length)
        ];

        return adjective + noun;
    }
}
