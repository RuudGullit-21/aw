
#Область ПрограммныйИнтерфейс

// Функция - Это конфигурация ЦСМ
// 
// Возвращаемое значение:
//	Булево 
//
Функция ЭтоКонфигурацияЦСМ() Экспорт
	
	Возврат Метаданные.Имя = ИмяКонфигурацииЦСМ();
	
КонецФункции
 
// Функция - Имя конфигурации ЦСМ
// 
// Возвращаемое значение:
//	Строка 
//
Функция ИмяКонфигурацииЦСМ() Экспорт
	
	Возврат "ЦентрСпутниковогоМониторинга";
	
КонецФункции

// Функция - Имя подсистемы ЦСМ
// 
// Возвращаемое значение:
//  Строка 
//
Функция ИмяПодсистемыЦСМ() Экспорт
	
	Возврат "Itob" + ИмяКонфигурацииЦСМ();
	
КонецФункции
 
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура УстановкаПараметровСеанса(ИменаПараметровСеанса) Экспорт
	 
	Если ИменаПараметровСеанса = Неопределено И ОбщегоНазначения.ПодсистемаСуществует("ItobЦентрСпутниковогоМониторинга.ПомощникНастройкиГеосервисов") Тогда
		МенеджерОбработкиПомощникНастройкиГеосервисов = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени("Обработка.ItobПомощникНастройкиГеосервисов");
		МенеджерОбработкиПомощникНастройкиГеосервисов.УстановкаПараметровСеанса();
	ИначеЕсли НЕ ИменаПараметровСеанса = Неопределено И НЕ ИменаПараметровСеанса.Найти("ItobАдресCsmSvc") = Неопределено Тогда
		КлиентскаяСтрокаСоединения = ПолучитьНавигационнуюСсылкуИнформационнойБазы();
		ItobОперативныйМониторинг.ОпределитьАдресCsmSvc(КлиентскаяСтрокаСоединения);
	КонецЕсли; 
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ItobЦентрСпутниковогоМониторинга.ПользователиИПраваДоступа") Тогда
		МодульПользователиИПраваДоступа = ОбщегоНазначения.ОбщийМодуль("ItobПользователиИПраваДоступа");
		МодульПользователиИПраваДоступа.УстановкаПараметровСеанса(ИменаПараметровСеанса);	
	КонецЕсли;
	
КонецПроцедуры
 
#КонецОбласти 
