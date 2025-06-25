# Дизайн

Ссылка на макет в Figma - https://www.figma.com/design/ElcIDP3PIp5iOE4dCtPGmd/%D0%97%D0%B0%D0%B4%D0%B0%D1%87%D0%B8?node-id=0-1&p=f&t=qFtVbnpTMblIFCG8-0

# Стек

- SwiftLint;
- Swift Package Manager (SPM);
- Архитектура приложения: VIPER;
- Минимальная версия операционной системы: iOS 16.

# CodeStyle

## Перенос параметров

> [!NOTE]
> Функция, имеющая больше двух параметров переносится на новую строку

**Пример функции с двумя параметрами :** <br>
```
func set(str: String, str: String) -> Int
```

**Пример функции с тремя и более параметрами :** <br>
```
func set(
    str: String,
    str: String,
    str: String
) -> Int
```

## Перенос скобок

**Пример:** <br>
```
let model = Model(
set1,
set2
)
```

## Нейминг функций / свойств

- func setup*Название*() - Настройка, что вызовется единожды

- func configure*Название*() - Переиспользование

- func get*Название*() / func fetch*Название* - Получение запроса

- func handle*Название*() - Обработка

- func map*Название*() - Маппинг из одного в другое

- func is*Название*() -> Bool - Функция, возвращающая bool

## Отступы

> [!NOTE]
> В классах и расширениях используется дополнительная пустая строка.
> В структурах, функциях и протоколах отступ не нужен.

**Пример использования класса:** <br>
```
class A {

func set() {}
}
```
**Пример использования расширения:** <br>
```
extension A {

func set() {}
}
```

**Пример использования структуры:** <br>
```
struct A {
func set() {}
}
```

> [!NOTE]
> Все константы выносятся в отдельный enum.

**Пример использования перечисления:** <br>
```
class A {

enum Constants {
    static let num = 1
}
}
```

## Разделение по MARK

- Constants;
- Public Properties;
- Internal Properties;
- Private Properties;
- Initializers;
- Public Methods;
- Internal Methods;
- Private Methods.

**Пример:** <br>
```
class A {
// MARK: - Constants
// MARK: - Initializers
}
```

## Комментарии

Комментарии пишутся по возможности на свойства / функции, но если логика названия свойства или функции простая и понятная, то комментарий можно не писать.

**Пример:** <br>
```
/// Проверка на валидацию
var isValid: Bool
```

## Дополнительные сведения

Использование **self** без необходимости избегается.

По возможности используется SOLID, DRY, KISS и YAGNI.
