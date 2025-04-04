Skrypt zgaduje ciąg znaków przez kilka iteracji za pomocą jednej z dwóch strategii.

Użytkownik podaje za pomocą parametrów ciąg znaków który ma zostać odgadnięty, oraz strategię która ma zostać użyta do odgadnięcia ciągu: przyrostową lub losową.

Dla strategii losowej skrypt generuje nowy string o długości tej samej co wzór co iterację i porównuje go ze wzorem podanym rpzez użytkownika. Skrypt kończy działanie jeśli są one identyczne.

Dla strategii przyrostowej skrypt generuje losowy string o długości tej samej co wzór i porównuje go ze wzorem podanym rpzez użytkownika. Wszystkie litery które są takie same są zachowywane na swoich pozycjach, natomiast wszystkie inne są losowane ponownie. Skrypt kończy działanie w momencie kiedy string będzie identyczny ze wzorem.

Użytkownik może zdefiniować przez parametry żeby losowane były tylko małe litery lub wielkie i małe litery. Należy wtedy także sprawdzić czy string wzór zawiera tylko litery wyspecyfikowane przez użytkownika i zakończyć działanie z błędem jesli tak nie jest.

Skrypt wyświetla pomoc (wszystkie parametry i ich objaśnienia) jeśli użytkownik poda parametr -h.
