#!/usr/bin/perl

# -------> Individuelle Parameter des Skriptes - bitte anpassen!
# --> SMTP-Programm zum Versenden der Mail:
$Sendmail_Prog = "/usr/sbin/sendmail";
# --> Ziel-Mailadresse, an die gesendet werden soll:
$mailto = 'rolle@rolandschmitt.info';

# -------> Modul für CGI-Scripts einbinden:
use CGI;

# -------> Modul für CGI-Scripts zum Einlesen der Formulardaten anwenden:
$query = new CGI;
@names = $query->param;

# -------> interne Daten aus den erwarteten hidden-Feldern auslesen:
$delimiter = $query->param('delimiter');  # ---> Begrenzerzeichen zwischen name und value
$returnhtml = $query->param('return');    # ---> URL für Dankeseite
$subject = $query->param('subject');      # ---> E-Mail-Subject

# -------> alle Whitespace-Zeichen (Leerzeichen, Tabulator, Newline) in Leerzeichen wandeln
#             VERHINDERT sonst möglichen MISSBRAUCH des Skripts
$subject =~ s/\s/ /g;

# -------> Text der E-Mail aus den Formulardaten ermitteln:
$mailtext = "";
foreach(@names) {
  $name = $_;
  @values = "";
  @values = $query->param($name);
  if($name ne "return" && $name ne "subject" && $name ne "delimiter") {
    foreach $value (@values) {
      $mailtext = $mailtext.$name;
      $mailtext = $mailtext.$delimiter;
      $mailtext = $mailtext.$value."\n";
    }
  }
}

# -------> E-Mail versenden:
open(MAIL,"|$Sendmail_Prog -t") || print STDERR "Mailprogramm konnte nicht gestartet werden\n";
print MAIL "To: $mailto\n";
print MAIL "Subject: $subject\n\n";
print MAIL "$mailtext\n";
close(MAIL);

# -------> Dankeseite an Browser senden:
print "Location: $returnhtml\n\n";