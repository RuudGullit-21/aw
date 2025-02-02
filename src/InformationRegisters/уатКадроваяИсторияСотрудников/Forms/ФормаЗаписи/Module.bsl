
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Запись.Сотрудник) И Параметры.Свойство("Сотрудник") Тогда
		Запись.Сотрудник = Параметры.Сотрудник;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Запись.Организация) И Параметры.Свойство("Организация") Тогда
		Запись.Организация = Параметры.Организация;
	КонецЕсли;
	Если Параметры.Свойство("Период") Тогда
		Запись.Период = Параметры.Период;
	КонецЕсли;
	
	Если Запись.ИсходныйКлючЗаписи.Период = '00010101'
		И НЕ ЗначениеЗаполнено(Запись.Организация)
		И ЗначениеЗаполнено(Запись.Сотрудник.Организация) Тогда
		Запись.Организация = Запись.Сотрудник.Организация;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Запись.Организация) Тогда
		Элементы.Организация.ТолькоПросмотр = Ложь;
	КонецЕсли;
			
	УстановитьЗаголовокФормы();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.УправлениеДоступом
		УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ ПараметрыЗаписи.Свойство("БезПроверкиОрганизации") И ИзмененаОрганизацияСотрудника() Тогда
		Отказ = Истина;
		Оповещ = Новый ОписаниеОповещения("ПередЗаписьюВопрос", ЭтотОбъект);
		ТекстВопроса =
			"Будет изменена текущая организация сотрудника. Данные в отчетах по работе сотрудников за прошедший период станут некорректными. Продолжить?";
		ПоказатьВопрос(Оповещ, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюВопрос(Результат, ДопПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Записать(Новый Структура("БезПроверкиОрганизации", Истина));
		Если флЗакрытиеФормы Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	уатОбщегоНазначенияСервер.ОбновитьТекущееМестоРаботыВСправочникеСотрудники(ТекущийОбъект.Сотрудник, СообщениеОшибкаПриЗаписи);
			
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзменениеМестаРаботыСотрудника", Запись.Сотрудник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	флЗакрытиеФормы = Истина;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	флЗакрытиеФормы = Истина;
	флИзмененаОрганизация = ИзмененаОрганизацияСотрудника();
	Записать();
	Если НЕ флИзмененаОрганизация Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗапись(Команда)
	Оповещ = Новый ОписаниеОповещения("УдалитьЗаписьВопрос", ЭтотОбъект);
	ПоказатьВопрос(Оповещ, "Удалить запись?", РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗаписьВопрос(Результат, ДопПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		УдалитьЗаписьСервер();
		Оповестить("ИзменениеМестаРаботыСотрудника", Запись.Сотрудник);
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	Элементы.Организация.ТолькоПросмотр = Ложь;
	Элементы.ФормаВключитьВозможностьРедактирования.Доступность = Ложь;
	Элементы.ГруппаПодсказка.Видимость = Истина;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Запись.Сотрудник) Тогда
		Запись.Организация = уатОбщегоНазначенияТиповыеСервер.ПолучитьЗначениеРеквизита(Запись.Сотрудник, "Организация");
	КонецЕсли;
	
	УстановитьЗаголовокФормы()
КонецПроцедуры

&НаКлиенте
Процедура СотрудникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	уатЗащищенныеФункцииКлиент.ДиалогВыбораСотрудника(Элемент, Запись.Сотрудник, Новый Структура, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникОткрытие(Элемент, СтандартнаяОбработка)
	уатЗащищенныеФункцииКлиент.ОткрытьФормуСотрудника(Запись.Сотрудник, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	Если НЕ ЗначениеЗаполнено(Запись.Организация)
		И ЗначениеЗаполнено(Запись.Сотрудник) Тогда
		Запись.Организация = уатОбщегоНазначенияТиповыеСервер.ПолучитьЗначениеРеквизита(Запись.Сотрудник, "Организация");
	КонецЕсли;
	
	УстановитьЗаголовокФормы();
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УдалитьЗаписьСервер()
	ЗаписьМенеджер = РеквизитФормыВЗначение("Запись");
	ЗаписьМенеджер.Удалить();
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()
	Если Запись.Сотрудник.Пустая() Тогда
		Заголовок = "Прием на работу";
	Иначе
		тблСрез = РегистрыСведений.уатКадроваяИсторияСотрудников.СрезПервых(, Новый Структура("Сотрудник", Запись.Сотрудник));
		Если тблСрез.Количество() = 0 Тогда
			Заголовок = "Прием на работу """ + Запись.Сотрудник + """";
		Иначе
			Если Запись.Период <= тблСрез[0].Период Тогда
				Заголовок = "Прием на работу """ + Запись.Сотрудник + """";
			Иначе
				Заголовок = "Кадровый перевод """ + Запись.Сотрудник + """";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ИзмененаОрганизацияСотрудника()
	тблСрез = РегистрыСведений.уатКадроваяИсторияСотрудников.СрезПоследних(, Новый Структура("Сотрудник", Запись.Сотрудник));
	Если тблСрез.Количество() = 0 Тогда
		флЭтаЗаписьПоследняя = Истина;
	Иначе
		тблСрез.Сортировать("Период Убыв");
		флЭтаЗаписьПоследняя = (Запись.Период >= тблСрез[0].Период);
	КонецЕсли;
	
	Возврат НЕ Запись.Сотрудник.Пустая()
		И НЕ Запись.Сотрудник.Организация.Пустая()
		И флЭтаЗаписьПоследняя
		И Запись.Сотрудник.Организация <> Запись.Организация;
КонецФункции	

#КонецОбласти
