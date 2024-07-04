
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
	Элементы.ГруппаОтборПоОрганизациям.Видимость = ПолучитьФункциональнуюОпциюФормы("ФормироватьБюджетыПоОрганизациям");
	Элементы.ГруппаОтборПоПодразделениям.Видимость = ПолучитьФункциональнуюОпциюФормы("ФормироватьБюджетыПоПодразделениям");
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	Если Не НеобходимВыборСценария Тогда
		НепроверяемыеРеквизиты.Добавить("Сценарий");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидБюджетаПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицФормы

&НаКлиенте
Процедура ПодразделенияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИспользоватьОтборПоПодразделениям = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИспользоватьОтборПоОрганизациям = Истина;
	
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

&НаСервере
Процедура УправлениеФормой()
	
	НеобходимВыборСценария = Ложь;
	
	Если ЗначениеЗаполнено(ВидБюджета) Тогда
		ПараметрыДоступностиОтборов = Отчеты.БюджетныйОтчет.ПараметрыДоступностиОтборов(ВидБюджета);
		НеобходимВыборСценария = ПараметрыДоступностиОтборов.ДоступенВыборСценария;;
	КонецЕсли;
	
	Элементы.Сценарий.Видимость = НеобходимВыборСценария;
	
КонецПроцедуры

&НаСервере
Функция СохранитьНастройкиНаСервере()
	
	Реквизиты = Новый Массив();
	Реквизиты.Добавить("ВидБюджета");
	Если НеобходимВыборСценария Тогда
		Реквизиты.Добавить("Сценарий");
	КонецЕсли;
	Если ПолучитьФункциональнуюОпциюФормы("ФормироватьБюджетыПоОрганизациям") Тогда
		Реквизиты.Добавить("Организации");
	КонецЕсли;
	Если ПолучитьФункциональнуюОпциюФормы("ФормироватьБюджетыПоПодразделениям") Тогда
		Реквизиты.Добавить("Подразделения");
	КонецЕсли;
	
	Настройки = Перечисления.ТипыДействийШаговБюджетныхПроцессов.НастройкиДействия(ЭтаФорма, Реквизиты);
	Возврат ПоместитьВоВременноеХранилище(Настройки, Адрес);
	
КонецФункции

#КонецОбласти
