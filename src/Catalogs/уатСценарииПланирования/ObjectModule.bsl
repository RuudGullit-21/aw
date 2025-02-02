
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Раздел = Перечисления.уатРазделыПланирования.ПредоставленныеУслуги Тогда
		ПроверяемыеРеквизиты.Добавить("Валюта");
		ПроверяемыеРеквизиты.Добавить("ПолучательУслуг");
	ИначеЕсли Раздел = Перечисления.уатРазделыПланирования.ДоходыРасходы Тогда
		СтрокаРазрезСтатья = РазрезыПланирования.Найти(Перечисления.уатРазрезыПланирования.Статья, "РазрезПланирования");
		Если СтрокаРазрезСтатья = Неопределено ИЛИ СтрокаРазрезСтатья.ВариантАналитики.Пустая() Тогда
			ТекстСообщения = "Для сценария раздела ""Доходы и расходы"" обязательно указание в разрезах планирования статьи доходов или расходов.";
			уатОбщегоНазначенияСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,, "РазрезыПланирования", Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если Раздел <> Перечисления.уатРазделыПланирования.ОбъемыПеревозок Тогда
		уатОбщегоНазначенияСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ПараметрВыработки");
	КонецЕсли;
	
	Если ВидПланирования = Перечисления.уатВидыПланирования.Краткосрочный Тогда
		ПроверяемыеРеквизиты.Добавить("ВедущийСценарий");
	КонецЕсли;

	Если НЕ ЭтоГруппа
		И ИспользоватьКраткосрочноеПланирование Тогда
		ПроверяемыеРеквизиты.Добавить("ПериодичностьКраткосрочногоПланирования");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
