## Diese App ist noch in der Entwicklungsphase und aktuell noch nicht öffentlich zugänglich. 

Ich arbeite daran, eine zweite App zu erstellen, die als flexibler Lieferapp-Baukasten dient. Mit dieser Verwaltungs-App wirst du zukünftig die Möglichkeit haben, deine eigene Liefer-App individuell und einfach anzupassen, um sie perfekt auf dein Geschäft abzustimmen. Ich danke dir für dein Verständnis und deine Geduld während dieser spannenden Weiterentwicklung!
Der Api Code ist ein dummy und muss ausgewchselt werden.

## Lieferapp Vorlage
Ich habe vor einen richtigen Lieferapp Baukasten daraus zu machen.

## Besonderheiten von dieser App
### Rausfilter von Zutaten eines Gerichtes durch Bildanalyse
Ein Highlight von MeatNow ist unsere Bildanalyse. Anders als bei herkömmlichen Liefer-Apps, kannst du bei MeatNow ein Bild von einem Gericht hochladen und Stichpunkte dazu schreiben, und unsere App schlägt dir sofort passende Zutaten vor. So wird dein Einkauf nicht nur einfacher, sondern auch inspirierender. Dieses Feature unterstützt dich dabei, aus dem, was du du möchtest schneller zu bekommen.


## UI/UX
<img width="250" alt="Bildschirmfoto 2024-08-26 um 14 16 06" src="https://github.com/user-attachments/assets/c84507ea-e27a-497f-9dea-3216832239d3">
<img width="250" alt="Bildschirmfoto 2024-08-26 um 14 17 05" src="https://github.com/user-attachments/assets/2b032e74-1606-4e37-9a8f-6f4fc7ad6afa">
<img width="250" alt="Bildschirmfoto 2024-08-26 um 14 17 54" src="https://github.com/user-attachments/assets/4bd81043-b29c-4eaa-bdf9-ab2795e82f0f">
<img width="250" alt="Bildschirmfoto 2024-08-26 um 14 18 50" src="https://github.com/user-attachments/assets/52ddd253-8289-4f29-b2be-dd43aebc7280">
<img width="250" alt="Bildschirmfoto 2024-08-26 um 14 19 52" src="https://github.com/user-attachments/assets/7a49b0d0-ea34-4f7a-a382-989f3d3bf237">
<img width="250" alt="Bildschirmfoto 2024-08-26 um 14 20 52" src="https://github.com/user-attachments/assets/54d5903d-0f6c-4c76-9984-64fe997b7cf6">
<img width="250" alt="Bildschirmfoto 2024-08-26 um 14 21 11" src="https://github.com/user-attachments/assets/c1a73859-9ffd-40af-853f-e46519173abf">
<img width="250" alt="Bildschirmfoto 2024-08-26 um 14 21 32" src="https://github.com/user-attachments/assets/01ea725e-697f-4e06-aa6f-48004835b677">
<img width="250" alt="Bildschirmfoto 2024-08-26 um 14 22 54" src="https://github.com/user-attachments/assets/3caf8028-62fa-494f-8646-8c3cb6a047ec">
<img width="250" alt="Bildschirmfoto 2024-08-26 um 14 23 29" src="https://github.com/user-attachments/assets/d88b0b21-14fc-477f-b74d-36a58d827020">
<img width="250" alt="Bildschirmfoto 2024-08-26 um 14 23 40" src="https://github.com/user-attachments/assets/750ffa75-173a-49f9-9311-29c163f21d51">











### Features

## Zutatenanalyse aus Bildern
Beschreibung: Benutzer können ein Bild eines Gerichts hochladen, und die App analysiert das Bild mithilfe der OpenAI API, um die Zutaten zu erkennen. Diese werden dann in der App aufgelistet.

## Produktvorschläge basierend auf Zutaten
Beschreibung: Basierend auf den erkannten Zutaten schlägt die App passende Produkte vor, die direkt in den Warenkorb gelegt werden können. Diese Produkte werden aus der Firebase Firestore-Datenbank geladen.


## Technischer Aufbau

#### Projektaufbau
Das Projekt macht von der Software Architekture MVVM gebaucht und ist so strukturiert
#### Datenspeicherung
Die APP speichert die Daten der Nutzer, welche sich registrieren und ihre Bestellungen oder Produkte die in den Favoriten hinzugefügt wurden.

#### API Calls
Es wird die Api von OPEN AI Benutzt.


#### 3rd-Party Frameworks
FireBase

 
