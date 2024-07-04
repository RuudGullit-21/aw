#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатСправочникФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	Элементы.IDКонтакта.СписокВыбора.Очистить();
	Если ЗначениеЗаполнено(Объект.Контакт) Тогда
		Элементы.IDКонтакта.СписокВыбора.Добавить(Объект.IDКонтакта, Объект.Контакт);
	КонецЕсли;
	Элементы.ФормаЛогированиеЗапросов.Пометка = Объект.ЛогированиеЗапросов;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатСправочникФормаЭлементаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БиржаПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура IDКонтактаОчистка(Элемент, СтандартнаяОбработка)
	Объект.IDКонтакта = "";
	Объект.Контакт    = "";
КонецПроцедуры

&НаКлиенте
Процедура IDКонтактаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Объект.ТокенАвторизации) Тогда 
		ТекстОшибки = НСтр("ru='Необходимо заполнить токен.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "Объект.ТокенАвторизации");
		Возврат;
	КонецЕсли;
	ПодключениеКБиржеДоступно();
КонецПроцедуры

&НаКлиенте
Процедура IDКонтактаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Объект.Контакт = Элементы.IDКонтакта.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

&НаКлиенте
Процедура ЗаполнитьАдресПоУмолчанию(Команда)
	Объект.АдресСервиса = Элементы.АдресСервиса.ПодсказкаВвода;
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПроксиСервера(Команда)
	
	ПараметрыФормы = Неопределено;
	Если ОбщегоНазначенияКлиент.ИнформационнаяБазаФайловая() Тогда
		ПараметрыФормы = Новый Структура("НастройкаПроксиНаКлиенте", Истина);
	КонецЕсли;
	
	ПолучениеФайловИзИнтернетаКлиент.ОткрытьФормуПараметровПроксиСервера(ПараметрыФормы);

КонецПроцедуры

&НаКлиенте
Процедура ЛогированиеЗапросов(Команда)
	Элементы.ФормаЛогированиеЗапросов.Пометка = НЕ Элементы.ФормаЛогированиеЗапросов.Пометка;
	Объект.ЛогированиеЗапросов                = НЕ Объект.ЛогированиеЗапросов;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимость()
	
	Если Объект.Биржа = ПредопределенноеЗначение("Справочник.уатБиржиГрузоперевозок_уэ.АТИ") Тогда
		Элементы.АдресСервиса.ПодсказкаВвода = Нстр("en = 'https://api.ati.su'; ru = 'https://api.ati.su'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПодключениеКБиржеДоступно()
	
	ТабДанных   = Неопределено;
	ТекстОшибки = "";
	
	ИнформацияОбАккаунте = уатИнтеграции_уэ.АТИ_ПолучениеИнформацииОбАккаунте(Объект, ТекстОшибки);
	
	Элементы.IDКонтакта.СписокВыбора.Очистить();
	Если НЕ ЗначениеЗаполнено(ТекстОшибки) Тогда
		Если ЗначениеЗаполнено(ИнформацияОбАккаунте)
			И ИнформацияОбАккаунте.Свойство("Contacts") 
			И ТипЗнч(ИнформацияОбАккаунте.Contacts) = Тип("Массив") Тогда
			
			Контакты = ИнформацияОбАккаунте.Contacts;
			Для Каждого ТекСтрока Из Контакты Цикл
				Элементы.IDКонтакта.СписокВыбора.Добавить(СтрЗаменить(СтрЗаменить(Строка(ТекСтрока.ID), Символы.НПП, ""), " ", ""), ТекСтрока.Name);
			КонецЦикла;
			
		КонецЕсли;
		Возврат Истина;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

