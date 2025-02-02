#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Кэширует перечисление в структуре.
//
// Возвращаемое значение:
// 	 Структура - все значения в структура
//		Ключ - Имя значение
//		Значение - Ссылка на значение перчисления
//
Функция Кэш() Экспорт
	
	ЭтаСсылка = Перечисления.ВидыЭлементовФинансовогоОтчета;
	ЭтиМетаданные = Метаданные.Перечисления.ВидыЭлементовФинансовогоОтчета;
	Кэш = Новый Структура;
	Для Каждого Значение Из ЭтиМетаданные.ЗначенияПеречисления Цикл
		Кэш.Вставить(Значение.Имя,ЭтаСсылка[Значение.Имя]);
	КонецЦикла;
	Возврат Кэш;
	
КонецФункции

#КонецОбласти

#КонецЕсли