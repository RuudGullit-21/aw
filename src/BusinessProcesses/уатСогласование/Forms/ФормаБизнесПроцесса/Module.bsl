
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ВсеЗадачи.Отбор, "БизнесПроцесс", Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновлениеОтображения();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ВсеЗадачи.Отбор, "БизнесПроцесс", Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("БизнесПроцессИзменен", Объект.Ссылка);
	Если Объект.Стартован Тогда
		Оповестить("БизнесПроцессСтартован", Объект.Ссылка);
	КонецЕсли;
	
	ОбновлениеОтображения();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВсеЗадачиПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ПоказатьЗначение(Новый ОписаниеОповещения("ВсеЗадачиПередНачаломИзмененияЗавершение", ЭтотОбъект), Элементы.ВсеЗадачи.ТекущиеДанные.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПредметПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.Предмет) И (НЕ ЗначениеЗаполнено(Объект.Наименование) ИЛИ Объект.Наименование = "Согласовать ") Тогда 
		ТекстНСТР = НСтр("en='Agreed ""%1""';ru='Согласовать ""%1""'");
		Объект.Наименование = СтрШаблон(ТекстНСТР, Объект.Предмет);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИсполнители

&НаКлиенте
Процедура ИсполнителиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И Не Копирование Тогда
		Элемент.ТекущиеДанные.Исполнитель = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Карта(Команда)
	Если НЕ Объект.Ссылка.Пустая() Тогда
		ОткрытьФорму("БизнесПроцесс.уатСогласование.Форма.КартаМаршрута", Новый Структура("БизнесПроцесс", Объект.Ссылка), ЭтотОбъект);
	Иначе
		ТекстНСТР = НСтр("en='Business process is not recorded!';ru='Бизнес-процесс не записан!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШаблону(Команда)
	РезультатВыбора = Неопределено;

	ОткрытьФорму("Справочник.уатШаблоныСогласования.ФормаВыбора",,,,,, Новый ОписаниеОповещения("ЗаполнитьПоШаблонуЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновлениеОтображения()
	Если Объект.Стартован Тогда
		ТолькоПросмотр = Истина;
		Элементы.ГруппаВариант.Доступность = Ложь;
		Элементы.ФормаЗаполнитьПоШаблону.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШаблонуЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    РезультатВыбора = Результат;
    Если ТипЗнч(РезультатВыбора) = Тип("СправочникСсылка.уатШаблоныСогласования") И уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(РезультатВыбора, "ЭтоГруппа") = ЛОЖЬ Тогда 
        ЗаполнитьПоШаблонуСервер(РезультатВыбора);
        Модифицированность = Истина;
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоШаблонуСервер(Шаблон)
	СогласованиеОбъект = РеквизитФормыВЗначение("Объект");
	СогласованиеОбъект.ЗаполнитьПоШаблону(Шаблон);
	ЗначениеВРеквизитФормы(СогласованиеОбъект, "Объект");
КонецПроцедуры

&НаКлиенте
Процедура ВсеЗадачиПередНачаломИзмененияЗавершение(ДополнительныеПараметры) Экспорт
	Заглушка = Истина;
КонецПроцедуры

#КонецОбласти
