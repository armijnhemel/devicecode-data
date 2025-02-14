====== Telsey CPVA502+ / CPVA502+W ======

{{section>meta:infobox:432_warning#infobox_for_dataentries&noheader&nofooter&noeditbutton}}

Router sold by [[wp>Tele2|Tele2]]/Comunitel in Spain. TELSEY S.p.A. Mod: CPAJJJSE20TL2 ADSL/voIP 

{{:media:telsey:cpva502plus.png?150}}

Product page:
[[http://www.telsey.com/product_details.asp?cat=1&subcat=13&id_p=127|Telsey CPVA502+W]]

===== Supported Versions =====

Supported since AA [[https://dev.openwrt.org/changeset/30819|> R30819]]. 

^ Version     ^ Board Model     ^ wifi      ^ OpenWrt   ^ Notes                                                          ^
| CPVA502+W   | CPAJJJSE20TL2   | **Yes**   | ≥12.09   |  **ADSL/FXS/VoIP** not working in Openwrt, nor the USB slave.  |
| CPVA502+    | CPAJJUSE10TL2   | **No**    | ≥12.09   | :::                                                            |

<WRAP center round tip 60%>
Since this router has only 16 MiB RAM, old Backfire version may behave better.
</WRAP>

==== Firmwares ====
^ Version ^ Link ^ Notes ^
| Backfire 10.03.1 | [[https://docs.google.com/uc?export=download&id=0B-EMoBe-_OdBTVlmSFkybjBuX2M|Telsey_CPVA502_Backfire_10.03.1.zip]] | execute <code>mtd fixtrx linux</code> after the first boot|
| Attitude Adjustment 12.09 | [[https://downloads.openwrt.org/attitude_adjustment/12.09/brcm63xx/generic/openwrt-96348GW-generic-squashfs-cfe.bin|openwrt-96348GW-generic-squashfs-cfe.bin]] | may run out of memory |
| Barrier Breaker 14.07 | [[https://downloads.openwrt.org/barrier_breaker/14.07/brcm63xx/generic/openwrt-96348GW-generic-squashfs-cfe.bin|openwrt-96348GW-generic-squashfs-cfe.bin]] | may run out of memory |
| Trunk | [[https://downloads.openwrt.org/snapshots/trunk/brcm63xx/openwrt-96348GW-generic-squashfs-cfe.bin|openwrt-96348GW-generic-squashfs-cfe.bin]] | may run out of memory |
| OEM Telsey (from Comunitel ISP) | [[https://drive.google.com/uc?export=download&id=0B-EMoBe-_OdBNkNmbUhTZUh5NEU|Telsey_CPVA502_OEM_3.4.6V-h323.bin]] | **original firmware**, thanks to //TheMrRafus// for making a backup |
| Broadcom custom | [[https://docs.google.com/uc?export=download&id=0B-EMoBe-_OdBdi1qMU9VYVREYlU|Telsey_CPVA502_Broadcom_3.06L.06V.bin]] | custom build, non OpenWrt firmware |
| dummy, **only CFE** | [[https://drive.google.com/uc?export=download&id=0B-EMoBe-_OdBdTIwd3p5N3lkcjg|dummy_firmware-CFE_mod.bin]] | only for upgrading (modded) CFE, **reset button will work** |

===== Hardware Highlights =====
^ SoC ^ RAM ^ Flash ^ Network ^ USB ^ Serial ^ JTag ^
| BCM6348@256MHz | 16MiB | 4MiB | 2 x 1| slave | Yes | Yes |

===== Installation =====
  - -> [[:downloads]]
  - -> [[docs:guide-user:installation:generic.flashing|Install OpenWrt]]

==== Flash Layout ====
Please check out the article [[docs:techref:flash.layout]]. It contains an example and a couple of explanations.

^ partition ^ name ^ filesystem ^ description ^
| mtd0 | **CFE** | n/a | bootloader |
| n/a | n/a | n/a | firmware tag |
| mtd1 | **kernel** | RAM executable | kernel |
| mtd2 | **rootfs** | squashfs | root |
| mtd3 | **rootfs_data** | jffs2 | configuration, install new packages |
| mtd4 | **nvram** | n/a | OEM configuration data (PSI) |
| mtd5 | **linux** | n/a | OpenWrt upgrade |


==== firmware backup ====
Follow these steps to make a backup of the original firmware (before installing openwrt). Note you may need a Linux based OS installed at your computer to run some commands like **dd**.
  - Download the openwrt RAM firmware version [[https://docs.google.com/uc?export=download&id=0B-EMoBe-_OdBcGMxOE5DZjg4WlE|ram-firmware.elf]], it will be fully loaded in the RAM without writing in the flash chip and therefore it allows to backup the original firmware 
  - Install a TFTP server in your computer, and check it works ok. Copy ram-firware.elf file into the TFTP's server directory.
  - Plug the ethernet cable from your computer to the ETH0 port at the router, your computer must have a compatible IP with CFE, for example use **192.168.1.35**
  - Connect the [[#Serial|serial port]] at the router to your computer (3.3V ttl adapter required), and a run console software utility(putty, Cutecom or Hyperterminal) to comunicate with CFE. 
  - Plug the router's power source and look at the serial console, press any key to break into CFE. Now it's time to run the ram firmware, execute this command into the CFE command line <code>r 192.168.1.35:ram-firmware.elf</code>and wait few second until openwrt loads. 
  * In your computer execute <code>nc -l -p 5600|dd of=telsey-firmware_backup.bin</code> (nc = netcat)
  * In the router execute <code>cat /proc/mtd</code>We are interested in the linux partition. Execute: <code>dd if=/dev/mtd4|nc 192.168.1.35 5600</code>

Done, the firmware should be transfered to your computer: **telsey-firmware_backup.bin**

==== OEM easy installation ====

**From OEM firmware**\\
  * Browse to http://10.0.0.1:8063/ 
  * Go to //Management -> Update Software//
  * Select **.bin** firmware and press //Update Software//
  * Wait for it to reboot
  * Telnet to 192.168.1.1 and set a root password, or browse to http://192.168.1.1 if LuCI is installed.

**From CFE** (valid for all fimwares)\\
It seems the reset button doesn't work in this router, you may need to connect via serial port to stop CFE and then upload the image via web server. Alternatively you can shortcircuit TX and RX [[#serial|]] pins few seconds when turning on the router to enter CFE failsafe mode:
  *Browse to http://192.168.1.1/
  *Upload **.bin** file to router
  *Wait for it to reboot
  *Telnet to 192.168.1.1 and set a root password, or browse to http://192.168.1.1 if LuCI is installed.

==== OEM installation using the TFTP method ====

If you want to upgrade using TFTP you follow these steps (as an alternative to the above install process.
  * Connect the [[#serial|serial]] TTL cable to send commands to CFE for loading the firmware via tftp.
  * Start a TFTP server in your PC. Copy the //**openwrt-96348GW-generic-squashfs-cfe.bin**// firmware to the server.
  * Set the IP at your pc to 192.168.1.35 (or any compatible), and connect the ethernet cable to the router.
This is a session of flashing via TFTP:

<code>CFE> f 192.168.1.35:openwrt-96348GW-generic-squashfs-cfe.bin
Loading 192.168.1.35:openwrt-96348GW-generic-squashfs-cfe.bin ...
Finished loading 2686980 bytes

Flashing root file system and kernel at 0xbfc10000: ..........................................

.
*** Image flash done *** !
Resetting board...\0xff
</code>

==== Upgrading OpenWrt ====
->  [[docs:guide-user:installation:generic.sysupgrade]]

If you have already installed OpenWrt and like to reflash for e.g. upgrading to a new OpenWrt version you can upgrade using the mtd command line tool. It is important that you put the firmware image into the ramdisk (/tmp) before you start flashing.

=== LuCI Web Upgrade Process ===

  * Browse to http://192.168.1.1/cgi-bin/luci/mini/system/upgrade/ LuCI Upgrade URL
  * Upload image file for sysupgrade to LuCI
  * Wait for reboot

=== Terminal Upgrade Process ===

  * Login as root via SSH on 192.168.1.1
  * Use the following commands to upgrade.

<code>
cd /tmp/
wget http://downloads.openwrt.org/snapshots/trunk/brcm63xx/openwrt-96348GW-generic-squashfs-cfe.bin
sysupgrade /tmp/openwrt-96348GW-generic-squashfs-cfe.bin
</code>

  *If sysupgrade does not support this router, use the following commands.

<code>
cd /tmp/
wget http://downloads.openwrt.org/snapshots/trunk/brcm63xx/openwrt-96348GW-generic-squashfs-cfe.bin
mtd write /tmp/openwrt-96348GW-generic-squashfs-cfe.bin linux && reboot</code>

===== Basic configuration =====
-> [[docs:guide-quick-start:checks_and_troubleshooting|Basic configuration]] After flashing, proceed with this.\\
Set up your Internet connection, configure wireless, configure USB port, etc.


===== Specific Configuration =====
==== Interfaces ====
The default network configuration is:
^ Interface Name   ^ Description   ^ Default configuration   ^
| br-lan           | LAN & WiFi    | 192.168.1.1/24          |
| eth0             | WAN           | dhcp                    |
| eth1             | LAN           | bridged                 |
| wlan0            | WiFi          | disabled (bridged)      |

==== Failsafe mode ====
-> [[docs:guide-user:troubleshooting:failsafe_and_factory_reset]]

==== Buttons ====
-> [[docs:guide-user:hardware:hardware.button]] on howto use and configure the hardware button(s).

Only one hardware button, reset. Looks like CFE doesn't react when pressing this button to enter CFE failsafe mode.
^ label ^ event ^ GPIO ^ active ^
| R | reset | 36 | low |


===== Hardware =====
==== Info ====
| ^ CPVA502+W ^ CPVA502+ ^
| **[[wp>Instruction set|Instruction set]]:**    | [[wp>MIPS architecture|MIPS]] BE ||
| **Vendor:**          | [[wp>Broadcom]] ||
| **[[docs:techref:bootloader]]:**     | [[docs:techref:bootloader:cfe|CFE]] ||
| **Board Id**:   | CPVA502+ ||
| **[[docs:techref:hardware:soc|System-On-Chip]]:**  | {{:media:datasheets:bcm6348_kpbg_pinout.png?linkonly|BCM6348KPBG}} ||
| **[[docs:techref:hardware:cpu|CPU]] @Frq**        | BMIPS3300 V0.7 @256 MHz ||
| **Flash-Chip:**   | Macronix MX29LV320CTTC-90G                    | :?:            |
| **Flash size:**   | 4 MiB                                         ||
| **RAM-chips:**    | ESMT M12L64164A-7T / SDR-143                  | :?:            |
| **RAM size:**     | 16 MiB                                        ||
| **Wireless:**     | Broadcom BCM4318 802.11b/g (onboard)     | no wifi card   |
| **Ethernet:**     | 2x 10/100 Mbit (1x external AC201 + 1x internal phy)   ||
| **Internet:**     | ADSL2+ (not supported)                        ||
| **USB:**          | 1x1.1 slave                                   ||
| **FXS:**             | [[#fxsvoip|Le9581blc]] Digital SLIC |  |
| **[[docs:techref:hardware:port.serial|Serial]]:**   | [[#Serial|Yes]]   ||
| **[[docs:techref:hardware:port.jtag|JTAG]]:**       | [[#JTAG|Yes]]     | [[#JTAG|?]]|

==== Photos ====
Model Number: CPVA502+W

{{media:telsey:cpva502_front.jpg?direct&0x180|}} {{media:telsey:cpva502_back.jpg?direct&0x180|}}

==== Opening the case ====
**Note:** This will void your warranty!

  *To remove the cover do a/b/c

**CPVA502+W**

{{:media:telsey:telsey_arriba.jpg?400x300|}} {{:media:telsey:telsey_abajo.jpg?400x300|}} 

**CPVA502+** 

 {{media:telsey:cpva502a.jpg?0x260|}}  {{media:telsey:cpva502b.jpg?0x260|}}


==== Serial ====
-> [[docs:techref:hardware:port.serial]] general information about the serial port, serial port cable, etc.

How to connect to the Serial Port of this specific device:

{{media:telsey:cpva502_serialttl.jpg?direct&500|}}

**Settings:** 
  * Baudrate: 115200
  * Data bits: 8
  * Parity: None
  * Stop bits: 1

==== JTAG ====
-> [[docs:techref:hardware:port.jtag]] general information about the JTAG port, JTAG cable, etc.

How to connect to the JTAG Port of this specific device:

J202 pin Header. Verified pinout:
|   nTRST ^  1   ^  2   | GND   |
|     TDI ^  3   ^  4   | GND   |
|     TDO ^  5   ^  6   | GND   |
|     TMS ^  7   ^  8   | GND   |
|     TCK ^  9   ^  10  | GND   |
|   nSRST ^  11  ^  12  | GND   |

**Debrick**

This is a session of flashing a new CFE (AKA debrick) with urjtag employing a WIGGLER custom made cable:

<code>jtag> cable wiggler ppdev /dev/parport0    
Initializing ppdev port /dev/parport0
jtag> detect
IR length: 5
Chain length: 1
Device Id: 00000110001101001000000101111111 (0x0634817F)
  Manufacturer: Broadcom (0x17F)
  Part(0):      BCM6348 (0x6348)
  Stepping:     V1
  Filename:     /usr/share/urjtag/broadcom/bcm6348/bcm6348
jtag> endian big
jtag> initbus ejtag_dma
ImpCode=00000000100000000000100100000100
EJTAG version: <= 2.0
EJTAG Implementation flags: R4k DMA MIPS32
Clear memory protection bit in DCR
Clear Watchdog
Potential flash base address: [0x1f00000b], [0x1800]
Processor successfully switched in debug mode.
jtag> detectflash 0x1fc00000 
Query identification string:
        Primary Algorithm Command Set and Control Interface ID Code: 0x0002 (AMD/Fujitsu Standard Command Set)
        Alternate Algorithm Command Set and Control Interface ID Code: 0x0000 (null)
Query system interface information:
        Vcc Logic Supply Minimum Write/Erase or Write voltage: 2700 mV
        Vcc Logic Supply Maximum Write/Erase or Write voltage: 3600 mV
        Vpp [Programming] Supply Minimum Write/Erase voltage: 0 mV
        Vpp [Programming] Supply Maximum Write/Erase voltage: 0 mV
        Typical timeout per single byte/word program: 16 us
        Typical timeout for maximum-size multi-byte program: 0 us
        Typical timeout per individual block erase: 1024 ms
        Typical timeout for full chip erase: 0 ms
        Maximum timeout for byte/word program: 512 us
        Maximum timeout for multi-byte program: 0 us
        Maximum timeout per individual block erase: 16384 ms
        Maximum timeout for chip erase: 0 ms
Device geometry definition:
        Device Size: 4194304 B (4096 KiB, 4 MiB)
        Flash Device Interface Code description: 0x0002 (x8/x16)
        Maximum number of bytes in multi-byte program: 1
        Number of Erase Block Regions within device: 2
        Erase Block Region Information:
                Region 0:
                        Erase Block Size: 65536 B (64 KiB)
                        Number of Erase Blocks: 63
                Region 1:
                        Erase Block Size: 8192 B (8 KiB)
                        Number of Erase Blocks: 8
Primary Vendor-Specific Extended Query:
        Major version number: 1
        Minor version number: 1
        Address Sensitive Unlock: Required
        Erase Suspend: Read/write
        Sector Protect: 4 sectors per group
        Sector Temporary Unprotect: Not supported
        Sector Protect/Unprotect Scheme: 29BDS640 mode (Software Command Locking)
        Simultaneous Operation: Not supported
        Burst Mode Type: Supported
        Page Mode Type: Not supported
        ACC (Acceleration) Supply Minimum: 11500 mV
        ACC (Acceleration) Supply Maximum: 12500 mV
        Top/Bottom Sector Flag: Top boot device
jtag> flashmem 0x1fc00000 CFE.bin 
Chip: AMD Flash
        Manufacturer: Macronix
        Chip: MX29LV320CT
        Protected: 0000
program:
flash_unlock_block 0x1FC00000 IGNORE

block 0 unlocked
flash_erase_block 0x1FC00000
flash_erase_block 0x1FC00000 DONE
erasing block 0: 0
addr: 0x1FC0FFFE
verify:                                                                                                                                     
addr: 0x1FC0FFFE                                                                                                                            
Done.                                                                                                                                       
jtag> quit        
</code>

==== FXS / VoIP ====
The board is equiped with a FXS port and a [[http://www.microsemi.com/products/voice-line-circuits/ve950/le9581#overview|Le9581blc]] Digital SLIC chip. However there aren't available FOSS drivers for this part.

{{media:telsey:cpva502_slic.jpg?direct&400x300|}}  {{:media:datasheets:le88111-pinout.png?direct&0x300|}}

===== Debricking =====
-> [[docs:guide-user:troubleshooting:generic.debrick]]

===== Bootloader Mods =====
you could read about [[docs:techref:bootloader]] in general

About the possible boards with the CFE OEM bootlader
<code>CFE> b
Press:  <enter> to use current value

        '-' to go previous parameter

        '.' to clear the current value

        'x' to exit this command

Board Id Name (0-7)
96348W2          -------- 0
96348GW-10       -------- 1
CPVA4            -------- 2
MAGIC            -------- 3
MAGIC+           -------- 4
CPVA4V2          -------- 5
CPVL4            -------- 6
CPVA502+         -------- 7       :  7  </code>

Bootloaders available for this board:
^ link ^ description ^ md5sum ^
| [[https://docs.google.com/uc?export=download&id=0B-EMoBe-_OdBSllSMXZjZWhmRlU|CFE-telsey_CPVA502plus-OEM.bin]] | original bootloader backup, reset button doesn't work | <color grey>5578a0855ee2d1cff7ea383929963ad6</color> |
| [[https://docs.google.com/uc?export=download&id=0B-EMoBe-_OdBdGc3eWxTeEJhRGs|CFE-telsey_CPVA502plus-mod.bin]] | modded bootloader, reset button works for entering CFE failsafe mode, no firmware checksum | <color grey>51fdfbe21e9199dec2c5eb99da6512fa</color> |

===== Hardware mods =====
As a beginner, you really should inform yourself about [[docs:techref:hardware:soldering]] in general and then obtain some practical experience!

==== USB Mod ====
Probably the USB slave could be converted to host. See -> [[toh:inventel:dv4210#usb_mod|Livebox1: Slave to Host MOD]]

===== Bootlogs =====
==== OEM bootlog ====
<WRAP bootlog>
<nowiki>CFE version 1.0.37-3.6 for BCM96348 (32bit,SP,BE)
Build Date: ven lug 21 09:44:42 CEST 2006 (oliale@oliale.telsey.loc)
Copyright (C) 2003,2004,2005 Telsey Telecommunications.

Boot Address 0xbfc00000

Initializing Arena.
Initializing Devices.
Parallel flash device: name MX29LV320AT, id 0x22a7, size 4096KB
Auto-negotiation timed-out
10 MB Half-Duplex (assumed)
Check consistency for image tag [1]: Found good image at partition [1]
Check consistency for image tag [2]: No image found at partition [2]
CPU type 0x29107: 256MHz, Bus: 128MHz, Ref: 32MHz
Total memory: 16777216 bytes (16MB)

Total memory used by CFE:  0x80401000 - 0x80526FA0 (1204128)
Initialized Data:          0x8041E610 - 0x80420480 (7792)
BSS Area:                  0x80420480 - 0x80424FA0 (19232)
Local Heap:                0x80424FA0 - 0x80524FA0 (1048576)
Stack Area:                0x80524FA0 - 0x80526FA0 (8192)
Text (code) segment:       0x80401000 - 0x8041E60C (120332)
Boot area (physical):      0x00527000 - 0x00567000
Relocation Factor:         I:00000000 - D:00000000

Board IP address                  : 192.168.1.1  
Host IP address                   : 192.168.1.100  
Gateway IP address                :   
Run from flash/host (f/h)         : f  
Default host run file name        : vmlinux  
Default host flash file name      : bcm963xx_fs_kernel  
Boot delay (0-9 seconds)          : 1  
Board Id Name                     : CPVA502+  
Psi size in KB                    : 24
Number of MAC Addresses (1-32)    : 8  
Base MAC Address                  : 00:03:XX:XX:XX:XX  
Ethernet PHY Type                 : Internal
Memory size in MB                 : 16

mac server test........................### 
### Not default mac address
### 00 03 6f 75 de 58 
*** Press any key to stop auto run (1 seconds) ***
Auto run second count down: 110
Code Address: 0x80010000, Entry Address: 0x801a2018
Decompression OK!
Entry at 0x801a2018
Closing network.
Starting program at 0x801a2018
Linux version 2.6.8.1 (devluc@pisaur.telsey.loc) (gcc version 3.4.2) #1 Mon Oct 9 13:15:54 CEST 2006

Parallel flash device: name MX29LV320AT, id 0x22a7, size 4096KB

Total Flash size: 4096K with 71 sectors

CPVA502+ prom init

CPU revision is: 00029107

Determined physical RAM map:

 memory: 00fa0000 @ 00000000 (usable)

On node 0 totalpages: 4000

  DMA zone: 4000 pages, LIFO batch:1

  Normal zone: 0 pages, LIFO batch:1

  HighMem zone: 0 pages, LIFO batch:1

Built 1 zonelists

Kernel command line: root=31:0 ro noinitrd

brcm mips: enabling icache and dcache...

Primary instruction cache 16kB, physically tagged, 2-way, linesize 16 bytes.

Primary data cache 8kB 2-way, linesize 16 bytes.

PID hash table entries: 64 (order 6: 512 bytes)

Using 128.000 MHz high precision timer.

Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)

Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)

Memory: 14008k/16000k available (1321k kernel code, 1972k reserved, 282k data, 72k init, 0k highmem)

Calibrating delay loop... 255.59 BogoMIPS

Mount-cache hash table entries: 512 (order: 0, 4096 bytes)

Checking for 'wait' instruction...  unavailable.

NET: Registered protocol family 16

Can't analyze prologue code at 80158e14

PPP generic driver version 2.4.2

NET: Registered protocol family 24

Using noop io scheduler

bcm963xx_mtd driver v1.0

bcm963xx_mtd: rootfs_addr = 0xBFC10100, kernel_addr = 0xBFEAC100

brcmboard: brcm_board_init entry


 GPIO (0x4) LOW -- KIT ON POTS 

A confirm button interrupt is not configured on this board

CPU monitor calibration

Calibration loops: 51134656

bcm963xx_serial driver v2.0

NET: Registered protocol family 2

IP: routing cache hash table of 512 buckets, 4Kbytes

TCP: Hash tables configured (established 512 bind 1024)

NET: Registered protocol family 1

NET: Registered protocol family 17

Ebtables v2.0 registered

NET: Registered protocol family 8

NET: Registered protocol family 20

VFS: Mounted root (squashfs filesystem) readonly.

Freeing unused kernel memory: 72k freed


init started:  BusyBox v1.00 (2006.10.09-11:20+0000) multi-call binary
Algorithmics/MIPS FPU Emulator v1.5

BusyBox v1.00 (2006.10.09-11:20+0000) Built-in shell (msh)
Enter 'help' for a list of built-in commands.


Loading drivers and kernel modules... 

atmapi: module license 'Proprietary' taints kernel.

blaadd: blaa_detect entry

adsl: adsl_init entry

Broadcom BCMPROCFS v1.0 initialized

Broadcom BCM6348B0 Ethernet Network Device v0.3 Oct  9 2006 13:14:25

Config Internal PHY Through MDIO

BCM63xx_ENET: Auto-negotiation timed-out

BCM63xx_ENET: 10 MB Half-Duplex (assumed)

eth0: MAC Address: 00:03:XX:XX:XX:XX

Broadcom BCM6348B0 Ethernet Network Device v0.3 Oct  9 2006 13:14:25

Config External PHY Through MDIO

mii_init: mii hardware reset

BCM63xx_ENET: Auto-negotiation timed-out

BCM63xx_ENET: 10 MB Half-Duplex (assumed)

eth1: MAC Address: 00:03:XX:XX:XX:XX

Telsey BCM6348B0 USB Network Device v0.4 Oct  9 2006 13:14:29

usb0: MAC Address: 00 03 XX XX XX XX

usb0: Host MAC Address: 00 03 XX XX XX XX

Telsey CPVA502+-W, hwVer = 0xb, USB product ID set to 6310

MAGIC USB configuration

Endpoint: endpoint_init entry

BOS: Enter bosInit 

Enter bosAppInit 

Exit bosAppInit 

BOS: Exit bosInit 

Endpoint: endpoint_init COMPLETED

loading Broadcom WIFI module
PCI: Setting latency timer of device 0000:00:01.0 to 64

PCI: Enabling device 0000:00:01.0 (0004 -> 0006)

wl: srom not detected, using main memory mapped srom info (wombo board)

wl0: wlc_attach: using main board MAC address base in NVRAM (wombo board)

wl0 MAC Address: 00:03:XX:XX:XX:XX

wl0: Broadcom BCM4318 802.11 Wireless Controller 3.131.35.0.cpe2.3

dgasp: kerSysRegisterDyingGaspHandler: wl0 registered 

wlctl: wlctl: BcmAdsl_Initialize=0xC005E218, g_pFnNotifyCallback=0xC0078AD4

pSdramPHY=0xA0FFFFF8, 0x7995F 0xDEADBECF

AdslCoreHwReset: AdslOemDataAddr = 0xA0FF68A0

dgasp: kerSysRegisterDyingGaspHandler: dsl0 registered 

ip_tables: (C) 2000-2002 Netfilter core team

ip_conntrack version 2.1 (125 buckets, 0 max) - 368 bytes per conntrack

ip_conntrack_pptp version 2.1 loaded

ip_nat_pptp version 2.0 loaded

ip_conntrack_h323: init 

ip_nat_h323: initialize the module!

insmod: cannot open module `/lib/modules/2.6.8.1/kernel/net/ipv4/netfilter/broadcom/ip_conntrack_ipsec.ko': No such file or directory
insmod: cannot open module `/lib/modules/2.6.8.1/kernel/net/ipv4/netfilter/broadcom/ip_nat_ipsec.ko': No such file or directory
insmod: cannot open module `/lib/modules/2.6.8.1/kernel/net/ipv4/netfilter/ip_conntrack_sip.ko': No such file or directory

==>   Bcm963xx Software Version: 3.4.6V-h323.A2pB020a1.d17e   <==

device usb0 entered promiscuous mode

bcm63xxenet: Command 35318 not supported.

app: configure ethernet eth0 speed failed.
bcm63xxenet: Command 35317 not supported.

app: configure ethernet eth0 duplex type failed.
br0: port 1(usb0) entering learning state

br0: topology change detected, propagating

br0: port 1(usb0) entering forwarding state

device eth0 entered promiscuous mode

br0: port 2(eth0) entering learning state

br0: topology change detected, propagating

br0: port 2(eth0) entering forwarding state

bcm63xxenet: Command 35318 not supported.

app: configure ethernet eth1 speed failed.
bcm63xxenet: Command 35317 not supported.

app: configure ethernet eth1 duplex type failed.
device eth1 entered promiscuous mode

br0: port 3(eth1) entering learning state

br0: topology change detected, propagating

br0: port 3(eth1) entering forwarding state

Setting SSID "Telsey502plus"
Setting SSID "Guest"
pvc2684d: Interface "nas_0_44" created sucessfully

pvc2684d: Communicating over ATM 0.0.44, encapsulation: LLC

Starting the H323 application with the following parameters:H323 Gatekeeper address: 0.0.0.0H323 Gatekeeper ID: H323 Secondary Gatekeeper address: 0.0.0.0H323 Secondary Gatekeeper ID: H323 Gatekeeper port: 1719H323 Time to Live: 3600H323 Keep Alive Interval: 75 % of Time to LiveH323 Terminal Type: terminalH323 FastStart: Off (connect)H323 Alias: TelseyPhone Line1: Phone Line2: Dialplan Line1: .t4-Dialplan Line2: .t4-Supp. Services enable mask: 0x0:0x0User defined Supp. Services codes: Call Waiting Timeout (in seconds): 15Override Category: OffQ931 T301 Timer (in seconds): 180Q931 T303 Timer (in seconds): 4Q931 T310 Timer (in seconds): 120Starting restorebtnd...
No-answer timeout (in seconds): 120Offhook timeout (in seconds): 100H245 Tunneling: OffH245 Channel After Fast Start: OffEarly H245: OffOOB DTMF: OffAlerting PI: 8Progress PI: 8Bearer Capability: SpeechPlug change timeout (in seconds): OffH323 TOS: OffH323 Debugger: mode = Off --- level = ERRORCurrent global voice parameters:Codec G711U: Packet=20(ms) ec=On ss=Off Codec G711A: Packet=20(ms) ec=On ss=Off Codec G729: Packet=20(ms) ec=On ss=Off Codec priority order: G711U,G711A,G729 Country: ITALYCLID signal type: FSKHookFlash interval: 50-200 (ms)On-Hook detection timeout: 600 (ms)Squelch inband DTMF: OffFax feature: OnModem feature: OnPass through codec: OffNLP on Modem detection: OffNLP on Fax detection: OnRTP TOS: A0VodslSettings::getStrParam: Set default G729 configuration parameters (ec and ss)VodslSettings::setVar varName = codec_G729_ec, varValue = On
VodslSettings::setVar varName = codec_G729_ss, varValue = Off
Starting cpumond...
BcmWan_startInterface: vpi = 0, vci = 33, conId = 1
pWanId status = 0
BUFFER=vodsl h323start -p 0.0.0.0:1719-3600-75-terminal-Off-'' -i br0 -g 0.0.0.0-'' -G connect -c ITALY -s FSK -I 'Telsey' -n num:: -d ".t4-:.t4-" -m G711U,G711A,G729,:20-On-Off:20-On-Off:20-On-Off -t 50 -T 200 -H 600 -X 'Off' -Y 'Off' -S 'Off-A0' -e 'Off-On' -f 'On-On' -u none=0:0=0:0 -W 15 -O Off -L Off -N Off -E Off -B Speech -C Off -U 180 -V 4 -Z 120 -A 120 -F 100 -P 8:8 -o Off -D Off:ERROR &
BcmWan_startInterface: vpi = 0, vci = 44, conId = 1
pWanId status = 0
process `snmp' is using obsolete setsockopt SO_BSDCOMPAT

br0: port 2(eth0) entering disabled state

main(404): pppd 2.4.1 started by admin, uid 0
br0: port 3(eth1) entering disabled state

br0: port 1(usb0) entering disabled state

BOS: Enter bosInit 
Enter bosAppInit 
Exit bosAppInit 
BOS: Exit bosInit 
00:00:28 Address for host 0.0.0.0 resolved to 0.0.0.0 

00:00:28 Address for host 0.0.0.0 resolved to 0.0.0.0 

kernel::endpoint_open

kernel::endpoint_open COMPLETED

00:00:28 EndpointProvis entering: provisioning item 54

00:00:28 EndpointProvis  item=54 value=1

kernel:: endpoint provisioning

00:00:28 EndpointProvis entering: provisioning item 34

00:00:28 EndpointProvis  item=34 value=50

kernel:: endpoint provisioning

00:00:28 EndpointProvis entering: provisioning item 35

00:00:28 EndpointProvis  item=35 value=200

kernel:: endpoint provisioning

00:00:28 EndpointProvis entering: provisioning item 36

00:00:28 EndpointProvis  item=36 value=600

kernel:: endpoint provisioning

00:00:28 EndpointProvis entering: provisioning item 37

00:00:28 EndpointProvis  item=37 value=0

kernel:: endpoint provisioning

00:00:28 EndpointProvis entering: provisioning item 38

00:00:28 EndpointProvis  item=38 value=0

kernel:: endpoint provisioning

00:00:28 EndpointProvis entering: provisioning item 39

00:00:28 EndpointProvis  item=39 value=0

kernel:: endpoint provisioning

00:00:28 EndpointProvis entering: provisioning item 40

00:00:28 EndpointProvis  item=40 value=1

kernel:: endpoint provisioning

00:00:28 EndpointProvis entering: provisioning item 41

00:00:28 EndpointProvis  item=41 value=0

kernel:: endpoint provisioning

00:00:28 Endpoint Event task started with pid 389...

00:00:28 Endpoint Packet task started with pid 390 ...

Enter bosStartApp



bosAppRootTask() - Is it morning already? Spawning app task (epoch #0)...


Enter TaskCreate aoAP

TaskCreate - spawn new task aoAP

Exit TaskCreate 

AppResetDetectionEnable() - Enabled reset detection.

Exit bosStartApp

Enter TaskCreate HRTBEAT

TaskCreate - spawn new task HRTBEAT

Exit TaskCreate 

HEARTBEAT: Initialized!

slacLe9581Init: Init SLAC for country 10

slac6348Le9581.c: OpenSlac, boardId = 16777219

slac6348Le9581.c: OpenSlac, ABAT disabled

HEARTBEAT: Patient (AC power) pid=0 registered (1 of 16 max registered)

bosMsgQCreate: Created message queue VRGEVQ at address 0x0 

Enter TaskCreate VRGEVPR

TaskCreate - spawn new task VRGEVPR

Exit TaskCreate 

Enter TaskCreate HCAS

TaskCreate - spawn new task HCAS

Exit TaskCreate 


ENDPT: hdspVhdOpen Secondary Connection VHD success. DSP 0, VHD (0x50) of type: 0x3

HEARTBEAT: Patient (Cnx state) pid=1 registered (2 of 16 max registered)

HEARTBEAT: Patient (Endpt hookstate) pid=2 registered (3 of 16 max registered)

HEARTBEAT: Patient (Endpt On/Off signal) pid=3 registered (4 of 16 max registered)

HEARTBEAT: Patient (Endpt Caller ID signal) pid=4 registered (5 of 16 max registered)

HEARTBEAT: Patient (Endpt signal) pid=5 registered (6 of 16 max registered)

HEARTBEAT: Patient (Cnx signal) pid=6 registered (7 of 16 max registered)


ENDPT: hdspVhdOpen Primary Connection VHD success. DSP 0, VHD (0x51) of type: 0x0

HEARTBEAT: Patient (Cnx state) pid=7 registered (8 of 16 max registered)


ENDPT: hdspVhdOpen Line VHD success. DSP 0, VHD (0x52) of type: 0x7

ENDPT 0: Fax Custom Options set to 0x0

Default value for provItemId '47' did not exist

Default value for provItemId '210' did not exist

Default value for provItemId '63' did not exist

ENDPT: Initialization completed successfully for endpt 0


00:00:29 cmCallConfig: entering...
WO........0=*43#
WF........1=#43#
WQ........2=*#43#
RT........12=*31#
RO........13=*32#
RF........17=*33#
RESTORE DEFAULT........11=###*1973*5*2846*147896325*###
ENDPOINT 0:
00:00:29 rtpInit: RTCP task created, taskId = 5126
udpRawOpen: copying socketHandle b
00:00:29  RTP read thread started with pid 398 

udpRawSetSendHandle: copying rawHdl 0 senddesc b
udpRawOpen: copying socketHandle e
00:00:29  RTP read thread started with pid 399 

udpRawSetSendHandle: copying rawHdl 1 senddesc e
00:00:29  RTCP thread started with pid 397</nowiki>
</WRAP>\\

==== OpenWrt bootlog (Backfire)====
<WRAP bootlog>
<nowiki>CFE version 1.0.37-3.6 for BCM96348 (32bit,SP,BE)
Build Date: ven lug 21 09:44:42 CEST 2006 (oliale@oliale.telsey.loc)
Copyright (C) 2003,2004,2005 Telsey Telecommunications.

Boot Address 0xbfc00000

Initializing Arena.
Initializing Devices.
Parallel flash device: name MX29LV320AT, id 0x22a7, size 4096KB
100 MB Full-Duplex (auto-neg)
Check consistency for image tag [1]: Found good image at partition [1]
Check consistency for image tag [2]: No image found at partition [2]
CPU type 0x29107: 256MHz, Bus: 128MHz, Ref: 32MHz
Total memory: 16777216 bytes (16MB)

Total memory used by CFE:  0x80401000 - 0x80526FA0 (1204128)
Initialized Data:          0x8041E610 - 0x80420480 (7792)
BSS Area:                  0x80420480 - 0x80424FA0 (19232)
Local Heap:                0x80424FA0 - 0x80524FA0 (1048576)
Stack Area:                0x80524FA0 - 0x80526FA0 (8192)
Text (code) segment:       0x80401000 - 0x8041E60C (120332)
Boot area (physical):      0x00527000 - 0x00567000
Relocation Factor:         I:00000000 - D:00000000

Board IP address                  : 192.168.1.1
Host IP address                   : 192.168.1.100
Gateway IP address                : 
Run from flash/host (f/h)         : f
Default host run file name        : vmlinux
Default host flash file name      : bcm963xx_fs_kernel
Boot delay (0-9 seconds)          : 9
Board Id Name                     : CPVA502+
Psi size in KB                    : 24
Number of MAC Addresses (1-32)    : 8
Base MAC Address                  : 00:30:ab:00:00:01
Ethernet PHY Type                 : Internal
Memory size in MB                 : 16

mac server test........................
### Not default mac address
### 00 30 ab 00 00 01
*** Press any key to stop auto run (9 seconds) ***
Auto run second count down: 0
Code Address: 0x80010000, Entry Address: 0x80010000
Decompression OK!
Entry at 0x80010000
Closing network.
Starting program at 0x80010000
Linux version 2.6.32.27 (dani@tool) (gcc version 4.3.3 (GCC) ) #2 Sun Jan 27 20:42:36 CET 2013
Detected Broadcom 0x6348 CPU revision b0
CPU frequency is 256 MHz
16MB of RAM installed
registering 37 GPIOs
board_bcm963xx: CFE version: 1.0.37-3.6
bootconsole [early0] enabled
CPU revision is: 00029107 (Broadcom BCM6348)
board_bcm963xx: board name: CPVA502+
Determined physical RAM map:
 memory: 01000000 @ 00000000 (usable)
Initrd not found or empty - disabling initrd
Zone PFN ranges:
  Normal   0x00000000 -> 0x00001000
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0: 0x00000000 -> 0x00001000
Built 1 zonelists in Zone order, mobility grouping off.  Total pages: 4064
Kernel command line: root=/dev/mtdblock2 rootfstype=squashfs,jffs2 noinitrd console=ttyS0,115200
PID hash table entries: 64 (order: -4, 256 bytes)
Dentry cache hash table entries: 2048 (order: 1, 8192 bytes)
Inode-cache hash table entries: 1024 (order: 0, 4096 bytes)
Primary instruction cache 16kB, VIPT, 2-way, linesize 16 bytes.
Primary data cache 8kB, 2-way, VIPT, no aliases, linesize 16 bytes
Memory: 13472k/16384k available (2053k kernel code, 2912k reserved, 360k data, 132k init, 0k highmem)
Hierarchical RCU implementation.
NR_IRQS:128
Calibrating delay loop... 254.97 BogoMIPS (lpj=509952)
Mount-cache hash table entries: 512
NET: Registered protocol family 16
registering PCI controller with io_map_base unset
bio: create slab <bio-0> at 0
Switching to clocksource MIPS
PCI: Enabling device 0000:00:01.0 (0000 -> 0002)
ssb: Sonics Silicon Backplane found on PCI device 0000:00:01.0
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 512 (order: 0, 4096 bytes)
TCP bind hash table entries: 512 (order: -1, 2048 bytes)
TCP: Hash tables configured (established 512 bind 512)
TCP reno registered
NET: Registered protocol family 1
audit: initializing netlink socket (disabled)
type=2000 audit(0.312:1): initialized
squashfs: version 4.0 (2009/01/31) Phillip Lougher
Registering mini_fo version $Id$
JFFS2 version 2.2. (NAND) (SUMMARY)  Â© 2001-2006 Red Hat, Inc.
msgmni has been set to 26
io scheduler noop registered
io scheduler deadline registered (default)
gpiodev: gpio device registered with major 254
gpiodev: gpio platform device registered with access mask FFFFFFFF
bcm63xx_uart.0: ttyS0 at MMIO 0xfffe0300 (irq = 10) is a bcm63xx_uart
console [ttyS0] enabled, bootconsole disabled
console [ttyS0] enabled, bootconsole disabled
bcm963xx_flash: 0x00400000 at 0x1fc00000
bcm963xx: Found 1 x16 devices at 0x0 in 16-bit bank
 CFI mfr 0x000000c2
 CFI id  0x000022a7
 Amd/Fujitsu Extended Query Table at 0x0040
  Amd/Fujitsu Extended Query version 1.1.
bcm963xx: Swapping erase regions for broken CFI table.
number of CFI chips: 1
cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
bcm963xx_flash: Read Signature value of CFE1CFE1
bcm963xx_flash: CFE bootloader detected
bcm963xx_flash: CFE boot tag found with version 6 and board type 96348GW
bcm963xx_flash: Partition 0 is CFE offset 0 and length 10000
bcm963xx_flash: Partition 1 is kernel offset 10100 and length dff00
bcm963xx_flash: Partition 2 is rootfs offset f0000 and length 300000
bcm963xx_flash: Partition 3 is nvram offset 3f0000 and length 10000
bcm963xx_flash: Partition 4 is linux offset 10000 and length 3e0000
bcm963xx_flash: Spare partition is 280000 offset and length 170000
Creating 5 MTD partitions on "bcm963xx":
0x000000000000-0x000000010000 : "CFE"
0x000000010100-0x0000000f0000 : "kernel"
mtd: partition "kernel" must either start or end on erase block boundary or be smaller than an erase block -- forcing read-only
0x0000000f0000-0x0000003f0000 : "rootfs"
mtd: partition "rootfs" set to be root filesystem
mtd: partition "rootfs_data" created automatically, ofs=280000, len=170000
0x000000280000-0x0000003f0000 : "rootfs_data"
0x0000003f0000-0x000000400000 : "nvram"
0x000000010000-0x0000003f0000 : "linux"
bcm63xx_enet MII bus: probed
bcm63xx_enet MII bus: probed
bcm63xx_wdt started, timer margin: 30 sec
Registered led device: phone
Registered led device: link
Registered led device: eth1-nrst
TCP westwood registered
NET: Registered protocol family 17
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
VFS: Mounted root (squashfs filesystem) readonly on device 31:2.
Freeing unused kernel memory: 132k freed
Please be patient, while OpenWrt loads ...
- preinit -
Press the [f] key and hit [enter] to enter failsafe mode
- regular preinit -
switching to jffs2
mini_fo: using base directory: /
mini_fo: using storage directory: /overlay
- init -

Please press Enter to activate this console. bcm63xx_enet bcm63xx_enet.0: attached PHY at address 1 [Broadcom BCM63XX (1)]
bcm63xx_enet bcm63xx_enet.1: attached PHY at address 0 [Generic PHY]
device eth1 entered promiscuous mode
eth0: link UP - 100/full - flow control off
Compat-wireless backport release: compat-wireless-2011-11-29
Backport based on wireless-testing.git master-2011-12-01
cfg80211: Calling CRDA to update world regulatory domain
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
usbcore: registered new device driver usb
b43-phy0: Broadcom 4318 WLAN found (core revision 9)
Registered led device: b43-phy0::tx
Registered led device: b43-phy0::rx
Registered led device: b43-phy0::radio
Broadcom 43xx driver loaded [ Features: PL ]
PPP generic driver version 2.4.2
ip_tables: (C) 2000-2006 Netfilter Core Team
NET: Registered protocol family 24
nf_conntrack version 0.5.0 (212 buckets, 848 max)
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
bcm63xx_ohci bcm63xx_ohci.0: BCM63XX integrated OHCI controller
bcm63xx_ohci bcm63xx_ohci.0: new USB bus registered, assigned bus number 1
bcm63xx_ohci bcm63xx_ohci.0: irq 20, io mem 0xfffe1b00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected



BusyBox v1.15.3 (2013-01-27 14:49:55 CET) built-in shell (ash)
Enter 'help' for a list of built-in commands.

  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 ---------------------------------------------------
 Backfire (10.03.x Snapshot, r33081)
 ---------------------------------------------------
  * 1/3 shot Kahlua    In a shot glass, layer Kahlua
  * 1/3 shot Bailey's  on the bottom, then Bailey's,
  * 1/3 shot Vodka     then Vodka.
 ---------------------------------------------------
root@OpenWrt:/#</nowiki>
</WRAP>\\

===== Tags =====
[[meta:tags|How to add tags]]
{{tag>bcm63xx bcm6348 4flash 16ram 2port fastethernet 802.11bg}}