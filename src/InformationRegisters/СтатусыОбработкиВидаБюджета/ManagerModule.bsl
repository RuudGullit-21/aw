#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Функция возвращает значения статусов вида бюджета
//
// Параметры:
//  ВидБюджета	 - СправочникСсылка.ВидыБюджетов - ссылка на вид бюджета
//  Реквизиты	 - Строка, Структура			 - имена статусов, значения которых надо получить
//  Постфикс	 - Строка						 - "Отчет" или "Документ"
// 
// Возвращаемое значение:
//  Произвольный, Структура - значения статусов. Тип определяется в зависимости от типа параметра "Реквизиты"
//
Функция ПолучитьЗначениеСтатуса(ВидБюджета, Реквизиты, Постфикс = "") Экспорт
	
	Запись = РегистрыСведений.СтатусыОбработкиВидаБюджета.СоздатьМенеджерЗаписи();
	Запись.ВидБюджета = ВидБюджета;
	Запись.Прочитать();
	Если Не Запись.Выбран() Тогда
		Если ТипЗнч(Реквизиты) = Тип("Структура") Тогда
			Возврат Реквизиты;
		КонецЕсли;
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(Реквизиты) = Тип("Структура") Тогда
		Результат = Новый Структура;
		Для Каждого КлючИЗначение из Реквизиты Цикл
			Результат.Вставить(КлючИЗначение.Ключ, Запись[КлючИЗначение.Ключ + Постфикс]);
		КонецЦикла;
		Возврат Результат;
	КонецЕсли;
	
	Возврат Запись[Реквизиты + Постфикс];
	
КонецФункции

// Процедура устанавливает значение статуса
//
// Параметры:
//  ВидБюджета	 - СправочникСсылка.ВидыБюджетов - ссылка на вид бюджета
//  Реквизиты	 - Структура					 - значения статусов
//  Постфикс	 - 								 - 
//
Процедура УстановитьЗначениеСтатуса(ВидБюджета, Реквизиты, Постфикс = "") Экспорт
	
	Запись = РегистрыСведений.СтатусыОбработкиВидаБюджета.СоздатьМенеджерЗаписи();
	Запись.ВидБюджета = ВидБюджета;
	Запись.Прочитать();
	
	Если Не Запись.Выбран() Тогда
		Запись.ВидБюджета = ВидБюджета;
	КонецЕсли;

	Для Каждого КлючИЗначение из Реквизиты Цикл
		Запись[КлючИЗначение.Ключ + Постфикс] = КлючИЗначение.Значение;
	КонецЦикла;
	
	Запись.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли