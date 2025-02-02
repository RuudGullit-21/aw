
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ИдентификаторГлавногоХранилища") Тогда
		Возврат;
	КонецЕсли;

	ДанныеОбъекта = Справочники.ЭлементыФинансовыхОтчетов.ФормаПриСозданииНаСервере(ЭтотОбъект);
	ИдентификаторГлавногоХранилища = Параметры.ИдентификаторГлавногоХранилища;
	
	Если Не ЗначениеЗаполнено(СтатьяБюджетов) Тогда
		Заголовок = НСтр("en='<Статьи бюджетирования, по которым есть обороты>';ru='<Статьи бюджетирования, по которым есть обороты>'");
	Иначе
		Заголовок = Строка(Параметры.ВидЭлемента) + ": " + СтатьяБюджетов;
	КонецЕсли;
	
	Если Не Параметры.Свойство("НастройкаЯчеек") Тогда
		// авторасчет доступен только в сложной таблице
		Элементы.СпособЗаполнения.СписокВыбора.Удалить(1);
		
		ДеревоЭлементов = ДанныеФормыВЗначение(Параметры.ЭлементыОтчета, Тип("ДеревоЗначений"));
		АдресЭлементовОтчета = ПоместитьВоВременноеХранилище(ДеревоЭлементов, УникальныйИдентификатор);
		АдресТаблицыЭлементов = Неопределено;
	Иначе
		АдресТаблицыЭлементов = Параметры.АдресТаблицыЭлементов;
		АдресЭлементовОтчета = Параметры.АдресЭлементовОтчета;
	КонецЕсли;
	
	Если Не Параметры.Свойство("НастройкаЯчеек")
		И Не Параметры.Свойство("ПроизвольныйПоказатель") Тогда
		Элементы.ВыводимыеПоказатели.СписокВыбора.Добавить(Перечисления.ТипыВыводимыхПоказателейБюджетногоОтчета.КоличествоИСумма);
	КонецЕсли;
	
	ОперандыФормулы.Очистить();
	Для Каждого СтрокаОперанда из ДанныеОбъекта.ОперандыФормулы Цикл
		НоваяСтрока = ОперандыФормулы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОперанда);
	КонецЦикла;

	УправлениеФормой(ЭтотОбъект);
	
	//СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Формула) Тогда
		ТекущийОбъект.ЕстьНастройки = Истина;
	КонецЕсли;
	
	Если Формула = НСтр("en='<настроить авторасчет>';ru='<настроить авторасчет>'") ИЛИ
		Формула = НСтр("en='<настроить автозаполнение>';ru='<настроить автозаполнение>'") Тогда
		Формула = "";
	КонецЕсли;
	
	Справочники.ЭлементыФинансовыхОтчетов.ФормаПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, Отказ);
	
	Если ЗначениеЗаполнено(ЭтотОбъект.АдресЭлементаВХранилище) Тогда
		СтруктураЭлемента = ПолучитьИзВременногоХранилища(ЭтотОбъект.АдресЭлементаВХранилище);
		СтруктураЭлемента.ОперандыФормулы.Очистить();
		Для Каждого СтрокаОперанда из ОперандыФормулы Цикл
			Если Не ЗначениеЗаполнено(СтрокаОперанда.АдресСтруктурыЭлемента) Тогда
				СтрокаОперанда.АдресСтруктурыЭлемента = 
					БюджетнаяОтчетностьКлиентСервер.ПоместитьЭлементВХранилище(СтрокаОперанда.Операнд, ИдентификаторГлавногоХранилища);
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(СтруктураЭлемента.ОперандыФормулы.Добавить(), СтрокаОперанда);
		КонецЦикла;
		ПоместитьВоВременноеХранилище(СтруктураЭлемента, ЭтотОбъект.АдресЭлементаВХранилище);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(АдресЭлементаВХранилище) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФормулаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Формула = НСтр("en='<настроить автозаполнение>';ru='<настроить автозаполнение>'")
		ИЛИ Формула = НСтр("en='<настроить авторасчет>';ru='<настроить авторасчет>'") Тогда
		Формула = "";
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВидЭлемента", 						ПредопределенноеЗначение("Перечисление.ВидыЭлементовФинансовогоОтчета.ПроизводныйПоказатель"));
	ПараметрыФормы.Вставить("АдресЭлементаВХранилище", 			ПолучитьАдресВременногоОбъектаДляРедактированияФормулы());
	ПараметрыФормы.Вставить("АдресРедактируемогоЭлемента", 		АдресЭлементаВХранилище);
	ПараметрыФормы.Вставить("ИдентификаторГлавногоХранилища", 	ИдентификаторГлавногоХранилища);
	ПараметрыФормы.Вставить("ИспользоватьДляВводаПлана", 		ИспользоватьДляВводаПлана);
	ПараметрыФормы.Вставить("СпособЗаполнения", 				СпособЗаполнения);
	ПараметрыФормы.Вставить("АдресТаблицыЭлементов", 			АдресТаблицыЭлементов);
	ПараметрыФормы.Вставить("АдресЭлементовОтчета", 			АдресЭлементовОтчета);
	ПараметрыФормы.Вставить("ВариантРасположенияГраницыФактическихДанных", ВариантРасположенияГраницыФактическихДанных);
	
	Оповещение = Новый ОписаниеОповещения("ОбновитьПолеПослеИзмененияЭлемента", ЭтотОбъект, ПараметрыФормы);
	
	ОткрытьФорму("Справочник.ЭлементыФинансовыхОтчетов.ФормаОбъекта",
								ПараметрыФормы, ЭтотОбъект, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
КонецПроцедуры

&НаКлиенте
Процедура СпособЗаполненияПриИзменении(Элемент)
	
	Формула = "";
	ОперандыФормулы.Очистить();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	ФинансоваяОтчетностьКлиент.ЗавершитьРедактированиеЭлементаОтчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	//СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	Заглушка = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Если Форма.СпособЗаполнения = 0 Тогда
		Форма.Элементы.Формула.Гиперссылка = Ложь;
		Если ПустаяСтрока(Форма.Формула) Тогда
			Форма.Формула = "";
		КонецЕсли;
	ИначеЕсли Форма.СпособЗаполнения = 1 Тогда
		Форма.Элементы.Формула.Гиперссылка = Истина;
		Если ПустаяСтрока(Форма.Формула) Тогда
			Форма.Формула = НСтр("en='<настроить авторасчет>';ru='<настроить авторасчет>'");
		КонецЕсли;
	Иначе
		Форма.Элементы.Формула.Гиперссылка = Истина;
		Если ПустаяСтрока(Форма.Формула) Тогда
			Форма.Формула = НСтр("en='<настроить автозаполнение>';ru='<настроить автозаполнение>'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресВременногоОбъектаДляРедактированияФормулы()
	
	БуферныйОбъект = ФинансоваяОтчетностьКлиентСервер.СтруктураЭлементаОтчета();
	БуферныйОбъект.НаименованиеДляПечати = Объект.НаименованиеДляПечати;
	БуферныйОбъект.ВидЭлемента = Перечисления.ВидыЭлементовФинансовогоОтчета.ПроизводныйПоказатель;
	ФинансоваяОтчетностьВызовСервера.УстановитьЗначениеДополнительногоРеквизита(БуферныйОбъект, "Формула", Формула);
	БуферныйОбъект.ОперандыФормулы = ОперандыФормулы.Выгрузить();
	
	Возврат ПоместитьВоВременноеХранилище(БуферныйОбъект, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ПрочитатьДанныеФормулыИзВременногоХранилища(Адрес)
	
	БуферныйОбъект = ПолучитьИзВременногоХранилища(Адрес);
	Формула = ФинансоваяОтчетностьВызовСервера.ЗначениеДополнительногоРеквизита(БуферныйОбъект, "Формула");
	ОперандыФормулы.Загрузить(БуферныйОбъект.ОперандыФормулы);
	
	Если ПустаяСтрока(Формула) Тогда
		Формула = НСтр("en='<настроить автозаполнение>';ru='<настроить автозаполнение>'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПолеПослеИзмененияЭлемента(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ПрочитатьДанныеФормулыИзВременногоХранилища(ДополнительныеПараметры.АдресЭлементаВХранилище);
	КонецЕсли;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти