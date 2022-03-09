import "pe"

rule foundSusElf {

        meta:

                author = "Duane Dunston"
                email = "dunston@champlain.edu"
                description = "Find files that is a Linux Elf file and smaller than 600K."
                version = "0.4"

        strings:

                $upx = "UPX!"

        condition:

                /* Check if an ELF binary, it is smaller than 600KB, and the string "UPX!" is within the first 1024 bytes of the file. */
                (uint32(0)==0x464c457f)
                and filesize < 600KB
                and $upx in (0..1024)

}

rule foundGoBinary {

        meta:

                author = "Duane Dunston"
                email = "dunston@champlain.edu"
                description = "Find files that is a Linux Elf file and smaller than 600K."
                version = "0.2"

        strings:

                $go = "GODEBUG"

        condition:

                /* Find Go binaries */
                $go

}
