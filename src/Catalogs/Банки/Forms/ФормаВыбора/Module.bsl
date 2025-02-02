
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьПослеДобавления" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВыбранноеЗначение.Количество() Тогда 
		СоздатьОбновитьЭлементыСправочника(ВыбранноеЗначение);
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы_Список

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Не Копирование И Не Группа Тогда	
		Отказ = Истина;
		
		ТекстНСТР = НСтр("en='Select bank from classifier?';ru='Подобрать банк из классификатора?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("СписокПередНачаломДобавленияЗавершение", ЭтотОбъект), ТекстНСТР, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавленияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Результат = РезультатВопроса;
	Если Результат = КодВозвратаДиалога.Да Тогда    
		ПараметрыФормы = Новый Структура("ЗакрыватьПриВыборе, МножественныйВыбор", Ложь, Истина);
		ОткрытьФорму("Справочник.КлассификаторБанков.ФормаВыбора", ПараметрыФормы, Этаформа);
	Иначе
		ОткрытьФорму("Справочник.Банки.Форма.ФормаЭлемента");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьИзКлассификатора(Команда)
	
	ПараметрыФормы = Новый Структура("ЗакрыватьПриВыборе, МножественныйВыбор", Ложь, Истина);
	ОткрытьФорму("Справочник.КлассификаторБанков.ФормаВыбора", ПараметрыФормы, Этаформа);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура СоздатьОбновитьЭлементыСправочника(Знач мсвСсылок)
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ДанныеИзКлассификатора", мсвСсылок);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Банки.Ссылка КАК Банк,
	|	КлассификаторБанков.Ссылка КАК Классификатор
	|ИЗ
	|	Справочник.КлассификаторБанков КАК КлассификаторБанков
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Банки КАК Банки
	|		ПО КлассификаторБанков.Код = Банки.Код
	|ГДЕ
	|	КлассификаторБанков.Ссылка В(&ДанныеИзКлассификатора)";
	
	ТабСсылок = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ТекСсылка Из мсвСсылок Цикл 
		НайдСтрока = ТабСсылок.Найти(ТекСсылка, "Классификатор");
		Если НайдСтрока = Неопределено Тогда 
			НовОбъект = Справочники.Банки.СоздатьЭлемент();
			НовОбъект.Код = ТекСсылка.Код;
		Иначе 
			НовОбъект = НайдСтрока.Банк.ПолучитьОбъект();
		КонецЕсли;
		
		НовОбъект.Наименование = ТекСсылка.Наименование;
		
		НовОбъект.Родитель     = ПолучитьРодителя(ТекСсылка.Родитель);
		
		НовОбъект.КоррСчет     = ТекСсылка.КоррСчет;
		НовОбъект.Город        = ТекСсылка.Город;
		НовОбъект.Адрес        = ТекСсылка.Адрес;
		НовОбъект.Телефоны     = ТекСсылка.Телефоны;
		
		Попытка
			НовОбъект.Записать();
		Исключение
			ТекстНСТР = НСтр("en='Error while creating a new catalog element.';ru='Ошибка при создании нового элемента справочника.'") + Символы.ПС +
						НСтр("en='Error description:';ru='Описание ошибки:'") + " " + ОписаниеОшибки();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРодителя(Знач Группа)
	
	Если ЗначениеЗаполнено(Группа) Тогда 
		мЗапрос = Новый Запрос();
		мЗапрос.УстановитьПараметр("Код", Группа.Код);
		
		мЗапрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Банки.Ссылка
		|ИЗ
		|	Справочник.Банки КАК Банки
		|ГДЕ
		|	Банки.ЭтоГруппа
		|	И Банки.Код = &Код";
		
		Рез = мЗапрос.Выполнить();
		
		Если Рез.Пустой() Тогда 
			НовГруппа = Справочники.Банки.СоздатьГруппу();
			НовГруппа.Код          = Группа.Код;
			НовГруппа.Наименование = Группа.Наименование;
			НовГруппа.Родитель     = ПолучитьРодителя(Группа.Родитель);
			
			Попытка
				НовГруппа.Записать();
				Возврат НовГруппа.Ссылка;
			Исключение
				ТекстНСТР = НСтр("en='Error when creating new catalog group.';ru='Ошибка при создании новой группы справочника.'") + Символы.ПС +
							НСтр("en='Error description:';ru='Описание ошибки:'") + " " + ОписаниеОшибки();
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
				Возврат Неопределено;
			КонецПопытки;
		Иначе 
			Выборка = Рез.Выбрать();
			Выборка.Следующий();
			Возврат Выборка.Ссылка;
		КонецЕсли;
		
	Иначе 
		Возврат Справочники.Банки.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции // ПолучитьРодителя()

#КонецОбласти
