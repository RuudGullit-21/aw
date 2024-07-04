
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если НЕ ЭтоГруппа Тогда
		Если ПорядокОтнесенияЗатрат = Перечисления.уатПорядкиОтнесенияРасходов.ПрямыеРасходы Тогда
			НайденнаяСтрока = ПроверяемыеРеквизиты.Найти("СпособРаспределенияЗатрат");
			Если НайденнаяСтрока <> Неопределено Тогда
				ПроверяемыеРеквизиты.Удалить(НайденнаяСтрока);
			КонецЕсли;
		ИначеЕсли СпособРаспределенияЗатрат = Перечисления.уатСпособыРаспределенияДоходовРасходовМеждуТС.ПоОбъемуВыработки
			ИЛИ СпособРаспределенияЗатрат = Перечисления.уатСпособыРаспределенияДоходовРасходовМеждуТС.ПоОбъемуВыработкиМЛ Тогда
			Если ВариантСпособаРаспределенияЗатрат = 0 Тогда
				ПроверяемыеРеквизиты.Добавить("ПараметрВыработкиРаспределенияМеждуТС");
			Иначе
				ПроверяемыеРеквизиты.Добавить("ПараметрыВыработкиРаспределенияМеждуТС.ПараметрВыработки");
			КонецЕсли;
		КонецЕсли;
		
		Если РаспределениеРасходовПоСцепкам Тогда
			ПроверяемыеРеквизиты.Добавить("СпособРаспределенияВнутриСцепки");
		КонецЕсли;
		
		Если РаспределятьНаРБП Тогда
			Если НЕ ЗначениеЗаполнено(СтатьяРасходов) Тогда
				ПроверяемыеРеквизиты.Добавить("СтатьяРасходов");
			ИначеЕсли СтатьяРасходов.РаспределятьНаРБП Тогда
				ТекстНСТР = НСтр("en='As an item of expenses for the distribution of deferred expenses, there should not be an item with the flag ""Distribute to deferred expenses""';ru='В статье расходов для распределения РБП не должен быть установлен флаг ""Распределять на РБП""'");
				уатОбщегоНазначенияСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстНСТР,,,"СтатьяРасходов", Отказ);
			КонецЕсли;
		КонецЕсли;
		
		Если ПараметрыВыработкиРаспределенияМеждуАналитиками.Найти(Перечисления.уатСпособыРаспределенияДоходовРасходовМеждуАналитиками.РаспределятьПоВыработке,
			"СпособРаспределенияЗатратМеждуАналитиками") <> Неопределено
			ИЛИ ПараметрыВыработкиРаспределенияМеждуАналитиками.Найти(Перечисления.уатСпособыРаспределенияДоходовРасходовМеждуАналитиками.РаспределятьПоЗаказам,
			"СпособРаспределенияЗатратМеждуАналитиками") <> Неопределено Тогда
			
			ПроверяемыеРеквизиты.Добавить("СпособРаспределениеНепрямыхРасходовПоЗаказам");
		КонецЕсли;
				
		флПараметрВыработкиНеИспользуется = Ложь;
		флСпособРаспределенияНеУказан = Ложь;
		Для Каждого Текстрока Из ПараметрыВыработкиРаспределенияМеждуАналитиками Цикл
			Если НЕ флСпособРаспределенияНеУказан И НЕ ЗначениеЗаполнено(Текстрока.СпособРаспределенияЗатратМеждуАналитиками) Тогда
				флСпособРаспределенияНеУказан = Истина;
			КонецЕсли;
			Если НЕ флПараметрВыработкиНеИспользуется
				И (Текстрока.СпособРаспределенияЗатратМеждуАналитиками = Перечисления.уатСпособыРаспределенияДоходовРасходовМеждуАналитиками.РаспределятьПоЗаказам
				И НЕ Текстрока.ПараметрВыработки.ДействуетНаТСМЛ)
				ИЛИ (Текстрока.СпособРаспределенияЗатратМеждуАналитиками = Перечисления.уатСпособыРаспределенияДоходовРасходовМеждуАналитиками.РаспределятьПоВыработке
				И НЕ ЗначениеЗаполнено(Текстрока.ПараметрВыработки)) Тогда
				флПараметрВыработкиНеИспользуется = Истина;
			КонецЕсли;
		КонецЦикла;
		Если флПараметрВыработкиНеИспользуется Тогда
			ТекстСообщения = "Параметр выработки распределения между аналитиками не указан или не используется при расчете услуг в путевых/маршрутных листах";
			уатОбщегоНазначенияСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,,, Отказ);
		КонецЕсли;
		Если флСпособРаспределенияНеУказан Тогда
			ТекстСообщения = "Не указан способ распределения между аналитиками";
			уатОбщегоНазначенияСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,,, Отказ);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти