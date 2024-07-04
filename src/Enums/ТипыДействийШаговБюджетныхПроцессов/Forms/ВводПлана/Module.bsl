
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Адрес = Параметры.Адрес;
	ШагПроцесса = Параметры.ШагПроцесса;
	МодельБюджетирования = Параметры.МодельБюджетирования;
	
	НастройкиДействия = ПолучитьИзВременногоХранилища(Адрес);
	Перечисления.ТипыДействийШаговБюджетныхПроцессов.ВосстановитьНастройкиДействия(НастройкиДействия, ЭтаФорма);
	
	ПараметрыОпций = Новый Структура("МодельБюджетирования", МодельБюджетирования);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыОпций);
	
	НастроитьСписокВыбораТиповПланов();
	УстановитьПараметрыВыбораСценария(Элементы.Сценарий, ТипПлана);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипПланаПриИзменении(Элемент)
	
	Сценарий = Неопределено;
	ВидПлана = Неопределено;
	УстановитьПараметрыВыбораСценария(Элементы.Сценарий, ТипПлана);
	
КонецПроцедуры

&НаКлиенте
Процедура СценарийПриИзменении(Элемент)
	
	СценарийПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПланаПриИзменении(Элемент)
	
	ВидПланаПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(СохранитьНастройкиНаСервере());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыВыбораСценария(ЭлементФормы, ТипПлана)
	
	МассивПараметровВыбора = Новый Массив;
	
	Если ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланЗакупок") Тогда
		МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("Отбор.ИспользоватьВПланированииЗакупок", Истина));
	ИначеЕсли ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПродаж") Тогда
		МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("Отбор.ИспользоватьВПланированииПродаж", Истина));
	ИначеЕсли ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПроизводства") Тогда
		МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("Отбор.ИспользоватьВПланированииПроизводства", Истина));
	ИначеЕсли ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланСборкиРазборки") Тогда
		МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("Отбор.ИспользоватьВПланированииСборкиРазборки", Истина));
	КонецЕсли;
	
	МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("Отбор.ОтражаетсяВБюджетировании", Истина));
	
	ЭлементФормы.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьСписокВыбораТиповПланов()
	
	СписокТипыПланов = Элементы.ТипПлана.СписокВыбора;
	СписокТипыПланов.Очистить();
	//Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеЗакупок") Тогда
	//	СписокТипыПланов.Добавить(Перечисления.ТипыПланов.ПланЗакупок);
	//КонецЕсли;
	//Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродаж") Тогда
	//	СписокТипыПланов.Добавить(Перечисления.ТипыПланов.ПланПродаж);
	//КонецЕсли;
	//Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПроизводства") Тогда
	//	СписокТипыПланов.Добавить(Перечисления.ТипыПланов.ПланПроизводства);
	//КонецЕсли;
	//Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеСборкиРазборки") Тогда
	//	СписокТипыПланов.Добавить(Перечисления.ТипыПланов.ПланСборкиРазборки);
	//КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТипПлана) И СписокТипыПланов.Количество() = 1 Тогда
		ТипПлана = СписокТипыПланов[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СценарийПриИзмененииСервер()
	
	ВидПлана = Планирование.ПолучитьВидПланаПоУмолчанию(ТипПлана, Сценарий);
	ВидПланаПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ВидПланаПриИзмененииСервер()
	
	Если ЗначениеЗаполнено(ВидПлана) И Не ЗначениеЗаполнено(СтатьяБюджетов) Тогда
		СтатьяБюджетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидПлана, "СтатьяБюджетов");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СохранитьНастройкиНаСервере()
	
	Реквизиты = Новый Массив;
	Реквизиты.Добавить("ТипПлана");
	Реквизиты.Добавить("Сценарий");
	Реквизиты.Добавить("ВидПлана");
	Реквизиты.Добавить("СтатьяБюджетов");
	
	Настройки = Перечисления.ТипыДействийШаговБюджетныхПроцессов.НастройкиДействия(ЭтаФорма, Реквизиты);
	Возврат ПоместитьВоВременноеХранилище(Настройки, Адрес);
	
КонецФункции

#КонецОбласти
