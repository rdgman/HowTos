'''bash
mtint@pop-os:~$ sudo dmidecode -s bios-version
[sudo] password for mtint:
1.39.0
mtint@pop-os:~$ fwupdmgr get-updates
Devices with no available firmware updates:
 • DELL097D:00 04F3:311C
 • PC611 NVMe SK hynix 1TB
 • Sabrent
 • Thunderbolt host controller
 • UEFI Device Firmware
 • UEFI Device Firmware
Devices with the latest available firmware version:
 • System Firmware
 • UEFI dbx
Update failure is a known issue, visit this URL for more information: https://github.com/fwupd/fwupd/wiki/LVFS-Triaged-Issue:-Linux-6.14-efivarfs-regression
Successfully uploaded 1 report
No updates available
mtint@pop-os:~$ fwupdmgr get-updates^C
mtint@pop-os:~$ sudo fwupdmgr get-devices
Dell Inc. XPS 15 9500
│
├─DELL097D:00 04F3:311C:
│     Device ID:          e00cb05db88599ee37a5a1aefa773424a160599a
│     Summary:            Touchpad
│     Current version:    0x000a
│     Bootloader Version: 0x0001
│     Vendor:             ELAN Microelectronics (HIDRAW:0x04F3)
│     GUIDs:              46598f8d-5777-50c4-8da9-cda0cc8bbc26 ← HIDRAW\VEN_04F3&DEV_311C
│                         d00322f0-ff1f-5458-9c64-8a771fb0b72e ← HIDRAW\VEN_04F3&DEV_311C&MOD_0000
│                         4f9fe0ae-f26e-5c1d-8a4e-a7506fb02f96 ← ELANTP\ICTYPE_13
│                         6cf7ae6a-8b98-5b63-9af8-b23b932f65de ← ELANTP\ICTYPE_13&MOD_0000
│                         ac3627a9-8463-5e63-b6b1-be9e0bcf27d2 ← ELANTP\ICTYPE_13&MOD_0000&DRIVER_HID
│     Device Flags:       • Internal device
│                         • Updatable
│
├─CometLake-H GT2 [UHD Graphics]:
│     Device ID:          5792b48846ce271fab11c4a545f7a3df0d36e00a
│     Current version:    05
│     Vendor:             Intel Corporation (PCI:0x8086)
│     GUIDs:              3777783a-3f83-56a5-95f4-533eb6a2bd19 ← PCI\VEN_8086&DEV_9BC4
│                         7df680f4-5dda-5d16-8faa-e7c92998646a ← PCI\VEN_8086&DEV_9BC4&SUBSYS_1028097D
│     Device Flags:       • Internal device
│                         • Cryptographic hash verification is available
│
├─Core™ i7-10750H CPU @ 2.60GHz:
│     Device ID:          4bde70ba4e39b28f9eab1628f9dd6e6244c03027
│     Current version:    0x00000100
│     Vendor:             Intel
│     GUIDs:              b9a2dd81-159e-5537-a7db-e7101d164d3f ← cpu
│                         30249f37-d140-5d3e-9319-186b1bd5cac3 ← CPUID\PRO_0&FAM_06
│                         a45b0522-5722-54bd-b802-86cd044262df ← CPUID\PRO_0&FAM_06&MOD_A5
│                         7b9b6e8c-226c-5db6-86cb-ea3187578013 ← CPUID\PRO_0&FAM_06&MOD_A5&STP_2
│     Device Flags:       • Internal device
│
├─PC611 NVMe SK hynix 1TB:
│     Device ID:          f954c7acdf5fab61aeaca1cd71d29ea5ade6992f
│     Summary:            NVM Express solid state drive
│     Current version:    11002111
│     Vendor:             SK hynix (NVME:0x1C5C)
│     Serial Number:      NS11N88591060271A
│     GUIDs:              77f86fec-41c0-5e28-9195-417bf30a3589 ← STORAGE-DELL-109158
│                         8ef09b7a-b326-11e9-a2a3-2a2ae2dbcce4
│     Device Flags:       • Internal device
│                         • Updatable
│                         • System requires external power source
│                         • Needs a reboot after installation
│                         • Device is usable for the duration of the update
│                         • Signed Payload
│
├─Sabrent:
│     Device ID:          03281da317dccd2b18de2bd1cc70a782df40ed7e
│     Summary:            NVM Express solid state drive
│     Current version:    ECFM12.3
│     Vendor:             Phison Electronics Corporation (NVME:0x1987)
│     Serial Number:      27FF079807DE00037639
│     GUIDs:              a44eb54c-5441-56f2-8cc0-5e48964c6457 ← NVME\VEN_1987&DEV_5012
│                         94e27f4a-86e3-53a2-a728-18db5dd2be18 ← NVME\VEN_1987&DEV_5012&SUBSYS_19875012
│                         562f2e08-972d-5a08-8da1-a44ab1304cf8 ← Sabrent
│     Device Flags:       • Internal device
│                         • Updatable
│                         • System requires external power source
│                         • Needs shutdown after installation
│                         • Device is usable for the duration of the update
│
├─System Firmware:
│ │   Device ID:          a45df35ac0e948ee180fe216a5f703f32dda163f
│ │   Summary:            UEFI ESRT device
│ │   Current version:    1.39.0
│ │   Minimum Version:    1.39.0
│ │   Vendor:             Dell (DMI:Dell Inc.)
│ │   Update State:       Success
│ │   GUIDs:              57bd7271-c958-4190-a032-4d879ed219ce
│ │                       230c8b18-8d9b-53ec-838b-6cfc0383493a ← main-system-firmware
│ │   Device Flags:       • Internal device
│ │                       • Updatable
│ │                       • System requires external power source
│ │                       • Supported on remote server
│ │                       • Needs a reboot after installation
│ │                       • Cryptographic hash verification is available
│ │                       • Device is usable for the duration of the update
│ │
│ └─UEFI dbx:
│       Device ID:        362301da643102b9f38477387e2193e57abaa590
│       Summary:          UEFI revocation database
│       Current version:  20241101
│       Minimum Version:  20241101
│       Vendor:           UEFI:Linux Foundation
│       Install Duration: 1 second
│       GUIDs:            00fe3755-a4d8-5ef7-ba5f-47979fbb3423 ← UEFI\CRT_E28D59CA489BD2AD580F2EA5D62D6A29BB9C02AE5A818434A37DA7FC11DFF9E9
│                         4a6cd2cb-8741-5257-9d1f-89a275dacca7 ← UEFI\CRT_E28D59CA489BD2AD580F2EA5D62D6A29BB9C02AE5A818434A37DA7FC11DFF9E9&ARCH_X64
│                         c6682ade-b5ec-57c4-b687-676351208742 ← UEFI\CRT_A1117F516A32CEFCBA3F2D1ACE10A87972FD6BBE8FE0D0B996E09E65D802A503
│                         f8ba2887-9411-5c36-9cee-88995bb39731 ← UEFI\CRT_A1117F516A32CEFCBA3F2D1ACE10A87972FD6BBE8FE0D0B996E09E65D802A503&ARCH_X64
│       Device Flags:     • Internal device
│                         • Updatable
│                         • Supported on remote server
│                         • Needs a reboot after installation
│                         • Device is usable for the duration of the update
│                         • Only version upgrades are allowed
│                         • Signed Payload
│
├─TPM:
│     Device ID:          c6a80ac3a22083423992a3cb15018989f37834d6
│     Current version:    1.257.0.0
│     Vendor:             ST Microelectronics (TPM:STM)
│     GUIDs:              ff71992e-52f7-5eea-94ef-883e56e034c6 ← system-tpm
│                         84df3581-f896-54d2-bd1a-372602f04c32 ← TPM\VEN_STM&DEV_0001
│                         bfaed10a-bbc1-525b-a329-35da2f63e918 ← TPM\VEN_STM&MOD_
│                         70b7b833-7e1a-550a-a291-b94a12d0f319 ← TPM\VEN_STM&DEV_0001&VER_2.0
│                         06f005e9-cb62-5d1a-82d9-13c534c53c48 ← TPM\VEN_STM&MOD_&VER_2.0
│     Device Flags:       • Internal device
│                         • System requires external power source
│                         • Needs a reboot after installation
│                         • Device can recover flash failures
│                         • Full disk encryption secrets may be invalidated when updating
│                         • Signed Payload
│
├─TPM 2.0:
│     Device ID:          a3487e128cf1413519bce8e9a1ab3f5981e61458
│     Summary:            UEFI ESRT device
│     Current version:    0.1.1.1
│     Vendor:             Dell Inc. (PCI:0x1028)
│     Update State:       Success
│     Update Error:       Updating disabled due to TPM ownership
│     GUIDs:              aa1799d5-13cd-502d-ab9b-b24f5d73aecd ← 097d-2.0
│                         ff71992e-52f7-5eea-94ef-883e56e034c6 ← system-tpm
│                         73730635-f6c2-53da-9df2-948bb5ac1022 ← DELL-TPM-2.0-STM-
│     Device Flags:       • Internal device
│                         • System requires external power source
│
├─TU117M [GeForce GTX 1650 Ti Mobile]:
│     Device ID:          ce4c74a5188d5b9cdb1e72ed32dad2d313c1c999
│     Current version:    a1
│     Vendor:             NVIDIA Corporation (PCI:0x10DE, PCI:0x8086)
│     GUIDs:              6eec15ed-752e-5418-99ae-3171b61091ef ← PCI\VEN_10DE&DEV_1F95
│                         409d55de-02cb-5f56-8f4f-f5ffba5bb02d ← PCI\VEN_10DE&DEV_1F95&SUBSYS_1028097D
│                         d29269b6-e458-5f45-975c-9d52bb38e35f ← PCI\VEN_8086&DEV_1901
│                         61532b46-a2e8-5c17-9d57-315d51388a3d ← PCI\VEN_8086&DEV_1901&SUBSYS_1028097D
│     Device Flags:       • Internal device
│                         • Cryptographic hash verification is available
│
├─Thunderbolt host controller:
│     Device ID:          a7a0025394dd0c5c3ca589f14487f6e58c1a9ccc
│     Summary:            Unmatched performance for high-speed I/O
│     Current version:    65.00
│     Vendor:             Dell (THUNDERBOLT:0x00D4, TBT:0x00D4)
│     GUIDs:              361351ad-1a46-5a42-b7fe-13c9d8a7fc40 ← THUNDERBOLT\VEN_00D4&DEV_097D
│                         daeedfff-3bd8-5c15-9586-6bfe466b076a ← TBT-00d4097d-native
│                         0257530f-0fd5-5f43-a478-465a9a10fefe ← TBT-00d4097d-native-controller0-0
│     Device Flags:       • Internal device
│                         • Updatable
│                         • System requires external power source
│                         • Device stages updates
│                         • Signed Payload
│
├─UEFI Device Firmware:
│     Device ID:          349bb341230b1a86e5effe7dfe4337e1590227bd
│     Summary:            UEFI ESRT device
│     Current version:    256
│     Minimum Version:    256
│     Vendor:             DMI:Dell Inc.
│     Update State:       Success
│     GUID:               ffd6eef5-4372-4adc-8eeb-3dc0b7338375
│     Device Flags:       • Internal device
│                         • Updatable
│                         • System requires external power source
│                         • Needs a reboot after installation
│                         • Device is usable for the duration of the update
│
└─UEFI Device Firmware:
      Device ID:          2292ae5236790b47884e37cf162dcf23bfcd1c60
      Summary:            UEFI ESRT device
      Current version:    285221137
      Minimum Version:    285221137
      Vendor:             DMI:Dell Inc.
      Update State:       Success
      GUID:               8ef09b7a-b326-11e9-a2a3-2a2ae2dbcce4
      Device Flags:       • Internal device
                          • Updatable
                          • System requires external power source
                          • Needs a reboot after installation
                          • Device is usable for the duration of the update

mtint@pop-os:~$ sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates
Updating lvfs
Downloading…             [***********************************    ]
Successfully downloaded new metadata: 2 local devices supported
Devices with no available firmware updates:
 • DELL097D:00 04F3:311C
 • PC611 NVMe SK hynix 1TB
 • Sabrent
 • Thunderbolt host controller
 • UEFI Device Firmware
 • UEFI Device Firmware
Devices with the latest available firmware version:
 • System Firmware
 • UEFI dbx
No updates available
mtint@pop-os:~$
mtint@pop-os:~$ vi fwupd-healthcheck.sh
mtint@pop-os:~$ chmod +x !$
chmod +x fwupd-healthcheck.sh
mtint@pop-os:~$ ./fwupd-healthcheck.sh
=== Firmware Health Check (Sun  5 Oct 21:10:56 BST 2025) ===

BIOS version:
1.39.0

Refreshing LVFS metadata...
Updating lvfs
Downloading…             [ -                                     ]Downloading…             [ -                                     ]Downloading…             [  -                                    ]Downloading…             [   -                                   ]Downloading…             [    \                                  ]Downloading…             [     \                                 ]Downloading…             [      \                                ]Downloading…             [       \                               ]Downloading…             [        |                              ]Downloading…             [         |                             ]Downloading…             [          |                            ]Downloading…             [           |                           ]Downloading…: 36%
Downloading…             [**************                         ]Downloading…: 73%
Downloading…: 91%

Successfully downloaded new metadata: 2 local devices supported

Devices:
Dell Inc. XPS 15 9500
│
├─DELL097D:00 04F3:311C:
│     Device ID:          e00cb05db88599ee37a5a1aefa773424a160599a
│     Summary:            Touchpad
│     Current version:    0x000a
│     Bootloader Version: 0x0001
│     Vendor:             ELAN Microelectronics (HIDRAW:0x04F3)
│     GUIDs:              46598f8d-5777-50c4-8da9-cda0cc8bbc26 ← HIDRAW\VEN_04F3&DEV_311C
│                         d00322f0-ff1f-5458-9c64-8a771fb0b72e ← HIDRAW\VEN_04F3&DEV_311C&MOD_0000
│                         4f9fe0ae-f26e-5c1d-8a4e-a7506fb02f96 ← ELANTP\ICTYPE_13
│                         6cf7ae6a-8b98-5b63-9af8-b23b932f65de ← ELANTP\ICTYPE_13&MOD_0000
│                         ac3627a9-8463-5e63-b6b1-be9e0bcf27d2 ← ELANTP\ICTYPE_13&MOD_0000&DRIVER_HID
│     Device Flags:       • Internal device
│                         • Updatable
│
├─CometLake-H GT2 [UHD Graphics]:
│     Device ID:          5792b48846ce271fab11c4a545f7a3df0d36e00a
│     Current version:    05
│     Vendor:             Intel Corporation (PCI:0x8086)
│     GUIDs:              3777783a-3f83-56a5-95f4-533eb6a2bd19 ← PCI\VEN_8086&DEV_9BC4
│                         7df680f4-5dda-5d16-8faa-e7c92998646a ← PCI\VEN_8086&DEV_9BC4&SUBSYS_1028097D
│     Device Flags:       • Internal device
│                         • Cryptographic hash verification is available
│
├─Core™ i7-10750H CPU @ 2.60GHz:
│     Device ID:          4bde70ba4e39b28f9eab1628f9dd6e6244c03027
│     Current version:    0x00000100
│     Vendor:             Intel
│     GUIDs:              b9a2dd81-159e-5537-a7db-e7101d164d3f ← cpu
│                         30249f37-d140-5d3e-9319-186b1bd5cac3 ← CPUID\PRO_0&FAM_06
│                         a45b0522-5722-54bd-b802-86cd044262df ← CPUID\PRO_0&FAM_06&MOD_A5
│                         7b9b6e8c-226c-5db6-86cb-ea3187578013 ← CPUID\PRO_0&FAM_06&MOD_A5&STP_2
│     Device Flags:       • Internal device
│
├─PC611 NVMe SK hynix 1TB:
│     Device ID:          f954c7acdf5fab61aeaca1cd71d29ea5ade6992f
│     Summary:            NVM Express solid state drive
│     Current version:    11002111
│     Vendor:             SK hynix (NVME:0x1C5C)
│     Serial Number:      NS11N88591060271A
│     GUIDs:              77f86fec-41c0-5e28-9195-417bf30a3589 ← STORAGE-DELL-109158
│                         8ef09b7a-b326-11e9-a2a3-2a2ae2dbcce4
│     Device Flags:       • Internal device
│                         • Updatable
│                         • System requires external power source
│                         • Needs a reboot after installation
│                         • Device is usable for the duration of the update
│                         • Signed Payload
│
├─Sabrent:
│     Device ID:          03281da317dccd2b18de2bd1cc70a782df40ed7e
│     Summary:            NVM Express solid state drive
│     Current version:    ECFM12.3
│     Vendor:             Phison Electronics Corporation (NVME:0x1987)
│     Serial Number:      27FF079807DE00037639
│     GUIDs:              a44eb54c-5441-56f2-8cc0-5e48964c6457 ← NVME\VEN_1987&DEV_5012
│                         94e27f4a-86e3-53a2-a728-18db5dd2be18 ← NVME\VEN_1987&DEV_5012&SUBSYS_19875012
│                         562f2e08-972d-5a08-8da1-a44ab1304cf8 ← Sabrent
│     Device Flags:       • Internal device
│                         • Updatable
│                         • System requires external power source
│                         • Needs shutdown after installation
│                         • Device is usable for the duration of the update
│
├─System Firmware:
│ │   Device ID:          a45df35ac0e948ee180fe216a5f703f32dda163f
│ │   Summary:            UEFI ESRT device
│ │   Current version:    1.39.0
│ │   Minimum Version:    1.39.0
│ │   Vendor:             Dell (DMI:Dell Inc.)
│ │   Update State:       Success
│ │   GUIDs:              57bd7271-c958-4190-a032-4d879ed219ce
│ │                       230c8b18-8d9b-53ec-838b-6cfc0383493a ← main-system-firmware
│ │   Device Flags:       • Internal device
│ │                       • Updatable
│ │                       • System requires external power source
│ │                       • Supported on remote server
│ │                       • Needs a reboot after installation
│ │                       • Cryptographic hash verification is available
│ │                       • Device is usable for the duration of the update
│ │
│ └─UEFI dbx:
│       Device ID:        362301da643102b9f38477387e2193e57abaa590
│       Summary:          UEFI revocation database
│       Current version:  20241101
│       Minimum Version:  20241101
│       Vendor:           UEFI:Linux Foundation
│       Install Duration: 1 second
│       GUIDs:            00fe3755-a4d8-5ef7-ba5f-47979fbb3423 ← UEFI\CRT_E28D59CA489BD2AD580F2EA5D62D6A29BB9C02AE5A818434A37DA7FC11DFF9E9
│                         4a6cd2cb-8741-5257-9d1f-89a275dacca7 ← UEFI\CRT_E28D59CA489BD2AD580F2EA5D62D6A29BB9C02AE5A818434A37DA7FC11DFF9E9&ARCH_X64
│                         c6682ade-b5ec-57c4-b687-676351208742 ← UEFI\CRT_A1117F516A32CEFCBA3F2D1ACE10A87972FD6BBE8FE0D0B996E09E65D802A503
│                         f8ba2887-9411-5c36-9cee-88995bb39731 ← UEFI\CRT_A1117F516A32CEFCBA3F2D1ACE10A87972FD6BBE8FE0D0B996E09E65D802A503&ARCH_X64
│       Device Flags:     • Internal device
│                         • Updatable
│                         • Supported on remote server
│                         • Needs a reboot after installation
│                         • Device is usable for the duration of the update
│                         • Only version upgrades are allowed
│                         • Signed Payload
│
├─TPM:
│     Device ID:          c6a80ac3a22083423992a3cb15018989f37834d6
│     Current version:    1.257.0.0
│     Vendor:             ST Microelectronics (TPM:STM)
│     GUIDs:              ff71992e-52f7-5eea-94ef-883e56e034c6 ← system-tpm
│                         84df3581-f896-54d2-bd1a-372602f04c32 ← TPM\VEN_STM&DEV_0001
│                         bfaed10a-bbc1-525b-a329-35da2f63e918 ← TPM\VEN_STM&MOD_
│                         70b7b833-7e1a-550a-a291-b94a12d0f319 ← TPM\VEN_STM&DEV_0001&VER_2.0
│                         06f005e9-cb62-5d1a-82d9-13c534c53c48 ← TPM\VEN_STM&MOD_&VER_2.0
│     Device Flags:       • Internal device
│                         • System requires external power source
│                         • Needs a reboot after installation
│                         • Device can recover flash failures
│                         • Full disk encryption secrets may be invalidated when updating
│                         • Signed Payload
│
├─TPM 2.0:
│     Device ID:          a3487e128cf1413519bce8e9a1ab3f5981e61458
│     Summary:            UEFI ESRT device
│     Current version:    0.1.1.1
│     Vendor:             Dell Inc. (PCI:0x1028)
│     Update State:       Success
│     Update Error:       Updating disabled due to TPM ownership
│     GUIDs:              aa1799d5-13cd-502d-ab9b-b24f5d73aecd ← 097d-2.0
│                         ff71992e-52f7-5eea-94ef-883e56e034c6 ← system-tpm
│                         73730635-f6c2-53da-9df2-948bb5ac1022 ← DELL-TPM-2.0-STM-
│     Device Flags:       • Internal device
│                         • System requires external power source
│
├─TU117M [GeForce GTX 1650 Ti Mobile]:
│     Device ID:          ce4c74a5188d5b9cdb1e72ed32dad2d313c1c999
│     Current version:    a1
│     Vendor:             NVIDIA Corporation (PCI:0x10DE, PCI:0x8086)
│     GUIDs:              6eec15ed-752e-5418-99ae-3171b61091ef ← PCI\VEN_10DE&DEV_1F95
│                         409d55de-02cb-5f56-8f4f-f5ffba5bb02d ← PCI\VEN_10DE&DEV_1F95&SUBSYS_1028097D
│                         d29269b6-e458-5f45-975c-9d52bb38e35f ← PCI\VEN_8086&DEV_1901
│                         61532b46-a2e8-5c17-9d57-315d51388a3d ← PCI\VEN_8086&DEV_1901&SUBSYS_1028097D
│     Device Flags:       • Internal device
│                         • Cryptographic hash verification is available
│
├─Thunderbolt host controller:
│     Device ID:          a7a0025394dd0c5c3ca589f14487f6e58c1a9ccc
│     Summary:            Unmatched performance for high-speed I/O
│     Current version:    65.00
│     Vendor:             Dell (THUNDERBOLT:0x00D4, TBT:0x00D4)
│     GUIDs:              361351ad-1a46-5a42-b7fe-13c9d8a7fc40 ← THUNDERBOLT\VEN_00D4&DEV_097D
│                         daeedfff-3bd8-5c15-9586-6bfe466b076a ← TBT-00d4097d-native
│                         0257530f-0fd5-5f43-a478-465a9a10fefe ← TBT-00d4097d-native-controller0-0
│     Device Flags:       • Internal device
│                         • Updatable
│                         • System requires external power source
│                         • Device stages updates
│                         • Signed Payload
│
├─UEFI Device Firmware:
│     Device ID:          349bb341230b1a86e5effe7dfe4337e1590227bd
│     Summary:            UEFI ESRT device
│     Current version:    256
│     Minimum Version:    256
│     Vendor:             DMI:Dell Inc.
│     Update State:       Success
│     GUID:               ffd6eef5-4372-4adc-8eeb-3dc0b7338375
│     Device Flags:       • Internal device
│                         • Updatable
│                         • System requires external power source
│                         • Needs a reboot after installation
│                         • Device is usable for the duration of the update
│
└─UEFI Device Firmware:
      Device ID:          2292ae5236790b47884e37cf162dcf23bfcd1c60
      Summary:            UEFI ESRT device
      Current version:    285221137
      Minimum Version:    285221137
      Vendor:             DMI:Dell Inc.
      Update State:       Success
      GUID:               8ef09b7a-b326-11e9-a2a3-2a2ae2dbcce4
      Device Flags:       • Internal device
                          • Updatable
                          • System requires external power source
                          • Needs a reboot after installation
                          • Device is usable for the duration of the update


Available updates:
Devices with no available firmware updates:
 • DELL097D:00 04F3:311C
 • PC611 NVMe SK hynix 1TB
 • Sabrent
 • Thunderbolt host controller
 • UEFI Device Firmware
 • UEFI Device Firmware
Devices with the latest available firmware version:
 • System Firmware
 • UEFI dbx
No updates available

efivarfs mount state:
efivarfs on /sys/firmware/efi/efivars type efivarfs (rw,nosuid,nodev,noexec,relatime)


Report saved to: /home/mtint/fwupd-healthcheck_2025-10-05_211056.log
mtint@pop-os:~$
mtint@pop-os:~$ cat  fwupd-healthcheck.sh
#!/usr/bin/env bash
set -euo pipefail

LOG="${HOME}/fwupd-healthcheck_$(date +%F_%H%M%S).log"

{
  echo "=== Firmware Health Check ($(date)) ==="
  echo
  echo "BIOS version:"
  sudo dmidecode -s bios-version || true
  echo

  echo "Refreshing LVFS metadata..."
  sudo fwupdmgr refresh --force || true
  echo

  echo "Devices:"
  sudo fwupdmgr get-devices || true
  echo

  echo "Available updates:"
  sudo fwupdmgr get-updates || true
  echo

  echo "efivarfs mount state:"
  mount | grep efivarfs || true
  echo
} | tee "${LOG}"

echo
echo "Report saved to: ${LOG}"

mtint@pop-os:~$

'''
