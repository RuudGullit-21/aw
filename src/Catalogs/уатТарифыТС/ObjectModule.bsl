
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоЛогистика = уатОбщегоНазначенияПовтИсп.ВариантПоставкиКОРП();
	
	Если НЕ ЭтоГруппа Тогда
		
		Если ЭтоЛогистика Тогда
			ИспользуютсяГеозоны = Ложь;
		КонецЕсли;
		
		ТекОбластьДействия = ОбластьДействия.Получить();
		Если ТекОбластьДействия <> Неопределено
			И ТипЗнч(ТекОбластьДействия) = Тип("НастройкиКомпоновкиДанных")
			И ТекОбластьДействия.Отбор.Элементы.Количество() > 0 Тогда
			ОбластьДействияПредставление = уатОбщегоНазначенияТиповые.уатПолучитьПредставлениеОтбора(ТекОбластьДействия.Отбор);
			
			Если ЭтоЛогистика Тогда
				Для Каждого ТекОтбор Из ТекОбластьДействия.Отбор.Элементы Цикл
					Если ТекОтбор.Использование
						И (ТекОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГеозонаОтправления")
						ИЛИ ТекОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГеозонаНазначения")) Тогда
						
						ИспользуютсяГеозоны = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		Иначе
			ОбластьДействияПредставление = "";
		КонецЕсли;
		
		Если ТарифнаяСетка Тогда
			// Если это прейскурант поставщика, то нужно удалить области действия вида "Контрагент"
			Если Владелец.ПрейскурантПоставщика Тогда
				Сч = ОбластиТарифнойСетки.Количество() - 1;
				Пока Сч >= 0 Цикл
					ТекОтбор = ОбластиТарифнойСетки[Сч];
					Если ТекОтбор.ВидОбластиДействия = Перечисления.уатВидыОбластейДействияТарифовТС.Контрагент Тогда
						ОбластиТарифнойСетки.Удалить(Сч);
					КонецЕсли;
					Сч = Сч - 1;
				КонецЦикла;
			КонецЕсли;
			
			мсвВидыОбластей = Новый Массив;
			
			Для Каждого ТекСтрока Из СтрокиТарифнойСетки Цикл
				мсвОтбор = Новый Массив;
				Для Каждого ТекОтбор Из ОбластиТарифнойСетки Цикл
					Если ТекОтбор.ID <> ТекСтрока.ID Тогда
						Продолжить;
					КонецЕсли;
					
					Если мсвВидыОбластей.Найти(ТекОтбор.ВидОбластиДействия) = Неопределено Тогда
						мсвВидыОбластей.Добавить(ТекОтбор.ВидОбластиДействия);
					КонецЕсли;
					
					флСписокЗначений = Ложь;
					Для Каждого ТекЭл Из мсвОтбор Цикл
						Если ТекЭл.Представление = Строка(ТекОтбор.ВидОбластиДействия) Тогда
							Если ТипЗнч(ТекЭл.Значение) <> Тип("СписокЗначений") Тогда
								ВремЗнач = ТекЭл.Значение;
								ТекЭл.Значение = Новый СписокЗначений;
								ТекЭл.Значение.Добавить(ВремЗнач);
							КонецЕсли;
							
							ТекЭл.Значение.Добавить(ТекОтбор.ЗначениеОбластиДействия);
							ТекЭл.ВидСравнения = ВидСравнения.ВСписке;
							флСписокЗначений = Истина;
							Прервать;
						КонецЕсли;
					КонецЦикла;
					
					Если НЕ флСписокЗначений Тогда
						мсвТипов = Новый Массив;
						мсвТипов.Добавить(ТипЗнч(ТекОтбор.ЗначениеОбластиДействия));
						ТекТипЗначения = Новый ОписаниеТипов(мсвТипов);
						СтруктураСтроки = Новый Структура("Значение, Представление, ВидСравнения, Использование, ТипЗначения",
							ТекОтбор.ЗначениеОбластиДействия, Строка(ТекОтбор.ВидОбластиДействия), ВидСравнения.Равно, Истина, ТекТипЗначения);
						мсвОтбор.Добавить(СтруктураСтроки);
					КонецЕсли;
					
					// записываем флаг "ЭтоГруппа"
					Попытка
						Если ТекОтбор.ЗначениеОбластиДействия.ЭтоГруппа Тогда
							ТекОтбор.ЭтоГруппа = Истина;
						КонецЕсли;
					Исключение
					КонецПопытки;
				КонецЦикла;
				ТекСтрока.ОбластьДействияПредставление = уатОбщегоНазначенияТиповые.уатПолучитьПредставлениеОтбора(мсвОтбор);
			КонецЦикла;
			
			Если мсвВидыОбластей.Количество() > 0 Тогда
				Для Каждого ТекОбласть Из мсвВидыОбластей Цикл
					ОбластьДействияПредставление = ОбластьДействияПредставление + "; " + ТекОбласть;
				КонецЦикла;
				ОбластьДействияПредставление = Сред(ОбластьДействияПредставление, 3)
			КонецЕсли;
			
			Если ЭтоЛогистика Тогда
				ИспользуютсяГеозоны = (мсвВидыОбластей.Найти(Перечисления.уатВидыОбластейДействияТарифовТС.ГеозонаОтправления) <> Неопределено
					ИЛИ мсвВидыОбластей.Найти(Перечисления.уатВидыОбластейДействияТарифовТС.ГеозонаНазначения) <> Неопределено);
			КонецЕсли;
		Иначе		
			СтрокиТарифнойСетки.Очистить();
			ОбластиТарифнойСетки.Очистить();
			ЗначенияТарифнойСетки.Очистить();
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если МетодРасчета = Перечисления.уатМетодыРасчетаПоТарифам.ПроцентомОтСуммы И НЕ ТарифнаяСетка Тогда
		Если СложныйТариф Тогда
			Для Каждого ТекСтрока Из Тарифы Цикл
				Если Скидка И (ТекСтрока.Тариф < 0 ИЛИ ТекСтрока.Тариф > 100) Тогда
					ТекстСообщения = СтрШаблон("В строке %1 таблицы расчета значение тарифа равно %2, допустимый диапазон 0-100", ТекСтрока.НомерСтроки, ТекСтрока.Тариф);
					уатОбщегоНазначенияСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения, "Тарифы", ТекСтрока.НомерСтроки, "Тариф", Отказ);
				ИначеЕсли НЕ Скидка И (ТекСтрока.Тариф < 0 ИЛИ ТекСтрока.Тариф > 999) Тогда
					ТекстСообщения = СтрШаблон("В строке %1 таблицы расчета значение тарифа равно %2, допустимый диапазон 0-999", ТекСтрока.НомерСтроки, ТекСтрока.Тариф);
					уатОбщегоНазначенияСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения, "Тарифы", ТекСтрока.НомерСтроки, "Тариф", Отказ);
				КонецЕсли;
			КонецЦикла;
		Иначе
			ПроверяемыеРеквизиты.Добавить("Тариф");
			Если Скидка И (Тариф < 0 ИЛИ Тариф > 100) Тогда
				ТекстСообщения = СтрШаблон("Значение тарифа равно %1, допустимый диапазон 0-100", Тариф);
				уатОбщегоНазначенияСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,, "Тариф", Отказ);
			ИначеЕсли НЕ Скидка И (Тариф < 0 ИЛИ Тариф > 999) Тогда
				ТекстСообщения = СтрШаблон("Значение тарифа равно %1, допустимый диапазон 0-999", Тариф);
				уатОбщегоНазначенияСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,, "Тариф", Отказ);
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли НЕ (МетодРасчета = Перечисления.уатМетодыРасчетаПоТарифам.ФиксированнойСуммой И УсловиеПримененияФиксТарифа = 1)
		И МетодРасчета <> Перечисления.уатМетодыРасчетаПоТарифам.ПроцентомОтСуммы Тогда
		ПроверяемыеРеквизиты.Добавить("ПараметрВыработки");
	КонецЕсли;
	
	Если ПараметрВыработки = Справочники.уатПараметрыВыработки.КоличествоУпаковок Тогда 
		ПроверяемыеРеквизиты.Добавить("ВидУпаковки");
	ИначеЕсли ПараметрВыработки = Справочники.уатПараметрыВыработки.КоличествоКонтейнеров Тогда 
		ПроверяемыеРеквизиты.Добавить("ТипКонтейнера");
	ИначеЕсли ПараметрВыработки = Справочники.уатПараметрыВыработки.КоличествоТочекПоТипуПункта Тогда 
		ПроверяемыеРеквизиты.Добавить("ТипПункта");
	ИначеЕсли ПараметрВыработки = Справочники.уатПараметрыВыработки.КоличествоТочекПоВидуОперации Тогда 
		ПроверяемыеРеквизиты.Добавить("ТипТочкиМаршрута");
	КонецЕсли;
	
	Если ПараметрВыработки <> Справочники.уатПараметрыВыработки.СкладскаяОбработка 
		Или МетодРасчета <> Перечисления.уатМетодыРасчетаПоТарифам.ПоПараметруВыработки Тогда
		
		ИндексУдаляемого = ПроверяемыеРеквизиты.Найти("ВидСкладскойОперации");
		Если Не ИндексУдаляемого = Неопределено Тогда 
			ПроверяемыеРеквизиты.Удалить(ИндексУдаляемого);
		КонецЕсли;
		ИндексУдаляемого = ПроверяемыеРеквизиты.Найти("БазаТарифа");
		Если Не ИндексУдаляемого = Неопределено Тогда 
			ПроверяемыеРеквизиты.Удалить(ИндексУдаляемого);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти