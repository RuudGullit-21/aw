#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру обязательных / уникальных реквизитов элемента
// Если ДляЭлемента = Истина, возвращаемая структура содержит реквизиты для проверки элемента
// Если ДляГруппы = Истина, аналогично для группы
// Возвращаемая структура содержит строковые идентификаторы реквизитов или вложенные структуры для табличных частей
// Для реквизита значение структуры содержит число 1-Обязательный, 3-Уникальный
Функция ПолучитьОбязательныеРеквизиты(ДляЭлемента=Истина, ДляГруппы=Ложь) Экспорт
	ОбязательныеРеквизиты=Новый Структура();
	Возврат ОбязательныеРеквизиты;
КонецФункции

// Функция проверяет, допустимо ли изменение объекта
// Возвращает Истина, если изменения возможны, ложь иначе
// Если изменения доступны частично, возвращает ложь и структуру блокируемых на изменение реквизитов,
Функция ДоступностьИзменения(БлокироватьРеквизиты=Неопределено) Экспорт
	Возврат Истина;
КонецФункции

#КонецОбласти
