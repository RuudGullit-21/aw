#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// начало блока стандартных операций
	ДопПараметрыОткрытие = Новый Структура("ИмяФормы", ИмяФормы);
	уатЗащищенныеФункцииСервер.уатОбработкаФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	// конец блока стандартных операций
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// начало блока стандартных операций
	уатЗащищенныеФункцииКлиент.уатОбработкаФормаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	// конец блока стандартных операций
	
	ЗаполнитьСписокПараметрыВыработки();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ВсеПараметрыВыработкиПриИзменении(Элемент)
	ЗаполнитьСписокПараметрыВыработки();
КонецПроцедуры

&НаКлиенте
Процедура СписокПланыПримененияЗатратПриАктивизацииСтроки(Элемент)
	ТекСтрока = Элементы.СписокПланыПримененияЗатрат.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		ТекПланЗатрат = Неопределено;
	Иначе
		ТекПланЗатрат = ТекСтрока.Ссылка;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПараметрыВыработкиВесовойКоэффициентДоходовРасходовПриИзменении(Элемент)
	ТекСтрока = Элементы.СписокПараметрыВыработки.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьПараметрВыработки(ТекСтрока.Ссылка, ТекСтрока.ВесовойКоэффициентДоходовРасходов);
	Если ТекСтрока.ВесовойКоэффициентДоходовРасходов = 0 И (НЕ ВсеПараметрыВыработки) Тогда
		СписокПараметрыВыработки.Удалить(ТекСтрока);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПараметрыВыработкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле = Элементы.СписокПараметрыВыработкиНаименование ИЛИ Поле = Элементы.СписокПараметрыВыработкиКод Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(Неопределено, Элементы.СписокПараметрыВыработки.ТекущиеДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПоказателиСебестоимостиПриАктивизацииСтроки(Элемент)
	Попытка
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ПериодыДействияПоказателейСебестоимости.Отбор, "Тариф", Элементы.СписокПоказателиСебестоимости.ТекущиеДанные.Ссылка);
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ПериодыДействияПоказателейСебестоимости.Отбор, "Тариф", Неопределено);
	КонецПопытки;
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокПараметрыВыработки()
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатПараметрыВыработки.Ссылка,
	|	уатПараметрыВыработки.Код,
	|	уатПараметрыВыработки.Наименование КАК Наименование,
	|	уатПараметрыВыработки.ВесовойКоэффициентДоходовРасходов
	|ИЗ
	|	Справочник.уатПараметрыВыработки КАК уатПараметрыВыработки
	|ГДЕ
	|	НЕ уатПараметрыВыработки.ПометкаУдаления
	|" + ?(ВсеПараметрыВыработки, "", "
	|	И уатПараметрыВыработки.ВесовойКоэффициентДоходовРасходов > 0") + "
	|УПОРЯДОЧИТЬ ПО
	|	Наименование");
			
	тбл = Запрос.Выполнить().Выгрузить();
	
	ЗначениеВРеквизитФормы(тбл, "СписокПараметрыВыработки");
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьПараметрВыработки(ПараметрВыработки, ВесовойКоэффициентДоходовРасходов)
	Если ПараметрВыработки.ВесовойКоэффициентДоходовРасходов = ВесовойКоэффициентДоходовРасходов Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрВыработкиОбъект = ПараметрВыработки.ПолучитьОбъект();
	ПараметрВыработкиОбъект.ВесовойКоэффициентДоходовРасходов = ВесовойКоэффициентДоходовРасходов;
	Попытка
		ПараметрВыработкиОбъект.Записать()
	Исключение
		ТекстНСТР = НСтр("en='Failed to write output parameter!';ru='Не удалось записать параметр выработки!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
	КонецПопытки;
КонецПроцедуры

#КонецОбласти
