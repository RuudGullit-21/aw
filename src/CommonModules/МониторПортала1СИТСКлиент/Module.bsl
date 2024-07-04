///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает Монитор Портала 1С:ИТС.
//
// Параметры:
//	ДополнительныеПараметры - Структура, Неопределено - дополнительные параметры
//		открытия Монитора Портала 1С:ИТС;
//
Процедура ОткрытьМонитор(ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыФормыМонитора = Новый Структура;
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
		Для Каждого КлючЗначение Из ДополнительныеПараметры Цикл
			ПараметрыФормыМонитора.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
	ОткрытьФорму("Обработка.МониторПортала1СИТС.Форма", ПараметрыФормыМонитора, , Ложь);
	
КонецПроцедуры

#Область БСПНастройкиПрограммы

// Обработчик команды БИПМониторПортала1СИТС
// на форме панели администрирования "Интернет-поддержка и сервисы"
// Библиотеки стандартных подсистем.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма панели администрирования;
//	Команда - КомандаФормы - команда на панели администрирования.
//
Процедура ИнтернетПоддержкаИСервисы_МониторПортала1СИТС(Форма, Команда) Экспорт
	
	ОткрытьМонитор();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Общего назначения

// Вызывается при начале работы системы из
// ИнтернетПоддержкаПользователейКлиент.ПриНачалеРаботыСистемы().
//
Процедура ПриНачалеРаботыСистемы() Экспорт
	
	ПараметрыРаботыКлиентаПриЗапуске = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если Не ПараметрыРаботыКлиентаПриЗапуске.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПараметрыРаботыКлиентаПриЗапуске.Свойство("ИнтернетПоддержкаПользователей") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыИПП = ПараметрыРаботыКлиентаПриЗапуске.ИнтернетПоддержкаПользователей;
	Если Не ПараметрыИПП.Свойство("МониторПортала1СИТС") Тогда
		// Использование Монитора недоступно в текущем режиме работы
		// или в соответствии с настройками программы или пользователя.
		Возврат;
	КонецЕсли;
	
	ПараметрыМонитора = ИнтернетПоддержкаПользователейКлиент.ЗначениеИзФиксированногоТипа(
		ПараметрыИПП.МониторПортала1СИТС);
	
	Если Не ПараметрыМонитора.ПоказыватьПриНачалеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПараметрыМонитора.ИнтернетПоддержкаПодключена Тогда
		// Если Интернет-поддержка не подключена, тогда подключить Интернет-поддержку.
		// Открытие при начале работы с неподключенной Интернет-поддержкой доступно только
		// пользователю с правом подключения Интернет-поддержки.
		ПодключитьОбработчикОжидания("Подключаемый_ОткрытьМониторПортала1СИТССПодключениемИнтернетПоддержки", 1, Истина);
		Возврат;
	КонецЕсли;
	
	Если ПараметрыМонитора.ПриНаличииНовойИнформации Тогда
		// Глобальный обработчик ожидания для проверки наличия новой информации в Мониторе.
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьНаличиеНовойИнформацииВМонитореПортала1СИТС", 1, Истина);
	Иначе
		ДополнительныеПараметрыОткрытияМонитора = Новый Структура;
		ДополнительныеПараметрыОткрытияМонитора.Вставить("ПриНачалеРаботы", Истина);
		ОткрытьМонитор(ДополнительныеПараметрыОткрытияМонитора);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОткрытьМониторСПодключениемИнтернетПоддержки() Экспорт
	
	ТекстСообщения =
		НСтр("ru = 'Для работы с Монитором Портала 1С:ИТС необходимо подключить Интернет-поддержку пользователей.'");
	Если Не ИнтернетПоддержкаПользователейКлиент.ДоступноПодключениеИнтернетПоддержки() Тогда
		ПоказатьПредупреждение(, ТекстСообщения + Символы.ПС + НСтр("ru = 'Обратитесь к администратору.'; en = 'Contact administrator.'"));
		Возврат;
	КонецЕсли;
	
	ОбработчикРезультата = Новый ОписаниеОповещения("ПриОтветеНаВопросПодключитьИнтернетПоддержку", ЭтотОбъект);
	ТекстВопроса = ТекстСообщения + Символы.ПС + НСтр("ru = 'Подключить Интернет-поддержку пользователей?'");
	ПоказатьВопрос(ОбработчикРезультата, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

Процедура ПриОтветеНаВопросПодключитьИнтернетПоддержку(КодВозврата, ДополнительныеПараметры) Экспорт
	
	Если КодВозврата <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОбработчикРезультата = Новый ОписаниеОповещения("ПодключениеИнтернетПоддержкиЗавершение", ЭтотОбъект);
	ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОбработчикРезультата);
	
КонецПроцедуры

Процедура ПодключениеИнтернетПоддержкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОткрытьМонитор();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодключениеИнтернетПоддержкиПриНачалеРаботыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОткрытьМонитор(Новый Структура("ПриНачалеРаботы", Истина));
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьНаличиеНовойИнформацииВМонитореПортала1СИТС() Экспорт
	
	РезультатНачала = МониторПортала1СИТСВызовСервера.НачатьПроверкуНаличияНовойИнформации();
	
	Если ТипЗнч(РезультатНачала) = Тип("Структура") Тогда
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ДлительныеОперацииКлиент.ОжидатьЗавершение(
			РезультатНачала.ДлительнаяОперация,
			Новый ОписаниеОповещения("ПриЗавершенииЗадания", ЭтотОбъект),
			ПараметрыОжидания);
	Иначе
		ПриЗавершенииПроверкиНаличияНовойИнформации(РезультатНачала);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗавершенииЗадания(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат.КраткоеПредставлениеОшибки) Тогда
		ПриЗавершенииПроверкиНаличияНовойИнформации("Ошибка");
	Иначе
		ПриЗавершенииПроверкиНаличияНовойИнформации(ПолучитьИзВременногоХранилища(Результат.АдресРезультата));
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗавершенииПроверкиНаличияНовойИнформации(Результат)
	
	Если Результат = "Ошибка" Тогда
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Монитор Портала 1С:ИТС'"),
			Новый ОписаниеОповещения("ПриНажатииОповещенияОНаличииНовойИнформации", ЭтотОбъект),
			НСтр("ru = 'Не удалось проверить наличие новой информации.
				|Подробнее см. Журнал регистрации.'"),
			БиблиотекаКартинок.Ошибка32,
			,
			"МониторПортала1СИТС");
		
	ИначеЕсли Результат = "ДанныеИзменены" Тогда
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Монитор Портала 1С:ИТС'"),
			Новый ОписаниеОповещения("ПриНажатииОповещенияОНаличииНовойИнформации", ЭтотОбъект),
			НСтр("ru = 'Новая информация в Мониторе Портала 1С:ИТС.
				|Нажмите для просмотра.'"),
			БиблиотекаКартинок.ИнтернетПоддержкаПользователей,
			СтатусОповещенияПользователя.Важное,
			"МониторПортала1СИТС");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриНажатииОповещенияОНаличииНовойИнформации(ДополнительныеПараметры) Экспорт
	
	ОткрытьМонитор();
	
КонецПроцедуры

#КонецОбласти
