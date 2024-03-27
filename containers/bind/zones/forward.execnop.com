$TTL 2d    ; default TTL for zone

$ORIGIN execnop.com. ; base domain-name

; Start of Authority RR defining the key characteristics of the zone (domain)

@         IN      SOA   ns1.execnop.com. hostmaster.execnop.com. (

                                2003080800 ; serial number

                                12h        ; refresh

                                15m        ; update retry

                                3w         ; expiry

                                2h         ; minimum

                                )

           IN      NS      ns1.execnop.com.


kvm1            IN      A       192.168.140.1
workbench       IN      A       192.168.140.4

ns1             IN      A       192.168.141.4
ipa1            IN      A       192.168.141.5

km1             IN      A       192.168.142.10
kw1             IN      A       192.168.142.20