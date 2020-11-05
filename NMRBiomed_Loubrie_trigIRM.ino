int bouton = 12;

void setup() {
  pinMode(bouton, INPUT);
  pinMode(LED_BUILTIN,OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);
  int etat=LOW;
}

void loop() {
  int etat=digitalRead(bouton);
  if (etat==HIGH)
  {
    digitalWrite(LED_BUILTIN, HIGH);
    delay(650);
    digitalWrite(LED_BUILTIN, LOW);
    delay(7);
    digitalWrite(LED_BUILTIN, HIGH);
    delay(200);
  }
  if (etat==LOW)
  {
    digitalWrite(LED_BUILTIN, HIGH);
  }
}
