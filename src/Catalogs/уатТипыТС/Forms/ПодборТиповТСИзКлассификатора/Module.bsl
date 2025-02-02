
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗакрыватьПриВыборе = Ложь;
	ИмяМакета = "МакетКлассификатораОН";
	ЗаполнитьТаблицуТиповТС(ИмяМакета);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяМакетаПриИзменении(Элемент)
	ЗаполнитьТаблицуТиповТС(ИмяМакета);
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокТиповТСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработатьВыборВСпискеТиповТС(СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьВыполнить()
	
	ОбработатьВыборВСпискеТиповТС();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТиповТС(ИмяМакета)
	
	ТипыТС.Очистить();
	
	// Заполняет список типов кузовов из макета.
	МакетДанных = Справочники.уатТипыТС.ПолучитьМакет(ИмяМакета);
	КолСтрок = МакетДанных.ВысотаТаблицы;
	Для сч = 1 По КолСтрок Цикл
		НоваяСтрока = ТипыТС.Добавить();
		НоваяСтрока.Группа = МакетДанных.Область(сч,1,сч,1).Текст;
		НоваяСтрока.Наименование = МакетДанных.Область(сч,2,сч,2).Текст;
		ВидТСНаименование = МакетДанных.Область(сч,3,сч,3).Текст;
		ВидТСМетаданные = Метаданные.Перечисления.уатВидыТС.ЗначенияПеречисления.Найти(ВидТСНаименование);
		Если ВидТСМетаданные <> Неопределено Тогда
			НоваяСтрока.ВидТС = Перечисления.уатВидыТС[ВидТСМетаданные.Имя];
		КонецЕсли;
		
		НоваяСтрока.Самосвал = МакетДанных.Область(сч,4,сч,4).Текст;
		НоваяСтрока.ПолезныйРазмерДлина = МакетДанных.Область(сч,5,сч,5).Текст;
		НоваяСтрока.ПолезныйРазмерШирина = МакетДанных.Область(сч,6,сч,6).Текст;
		НоваяСтрока.ПолезныйРазмерВысота = МакетДанных.Область(сч,7,сч,7).Текст;
		НоваяСтрока.ОбъемКузова = МакетДанных.Область(сч,8,сч,8).Текст;
		НоваяСтрока.Грузоподъемность = МакетДанных.Область(сч,9,сч,9).Текст;
		НоваяСтрока.ТипКузоваНаименование = МакетДанных.Область(сч,10,сч,10).Текст;	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СохранитьВыбранныеСтроки(Знач ВыбранныеСтроки)
	
	ТекущаяСсылка = Неопределено;
	СправочникКузовов = Справочники.уатТипыКузовов;
	ТекущийСправочник = Справочники.уатТипыТС;
	
	Для каждого НомерСтроки Из ВыбранныеСтроки Цикл
		ТекущиеДанные = ТипыТС.НайтиПоИдентификатору(НомерСтроки);
		
		тГруппа = ТекущиеДанные.Группа;
		тНаименование = ТекущиеДанные.Наименование;
		
		СтрокаВБазе = ТекущийСправочник.НайтиПоНаименованию(СокрЛП(тНаименование), Истина);
		// Либо такой элемент в справочнике уже есть
		Если ЗначениеЗаполнено(СтрокаВБазе) Тогда
			Если НомерСтроки = Элементы.СписокТиповТС.ТекущаяСтрока Или ТекущаяСсылка = Неопределено Тогда
				ТекущаяСсылка = СтрокаВБазе;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		// Либо этот элемент нужно создать
		ТипТС = ТекущийСправочник.СоздатьЭлемент();
		
		// Находим тип кузова по наименованию. Если не находим - создаем новый элемент справочника уатТипыКузовов
		ТипКузоваНаименование = ТекущиеДанные.ТипКузоваНаименование;
		Если ТипКузоваНаименование <> "" Тогда
			ТипКузоваИзСправочника = СправочникКузовов.НайтиПоНаименованию(СокрЛП(ТипКузоваНаименование), Истина);
			Если ТипКузоваИзСправочника <> Неопределено И Не ТипКузоваИзСправочника.Пустая() Тогда
				ТипТС.ТипКузова = ТипКузоваИзСправочника;
			ИначеЕсли ТипКузоваИзСправочника.Пустая() Тогда
				ТипКузова = СправочникКузовов.СоздатьЭлемент();
				ТипКузова.Наименование = ТипКузоваНаименование;
				ТипКузова.Записать();
				ТипТС.ТипКузова = ТипКузова.Ссылка;
			КонецЕсли;
		КонецЕсли;
		
		// Находим группу по наименованию. Если не находим - создаем новуб группу справочника уатТипыТС
		Если тГруппа <> "" Тогда
			Запрос = Новый Запрос(
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	уатТипыТС.Ссылка
			|ИЗ
			|	Справочник.уатТипыТС КАК уатТипыТС
			|ГДЕ
			|	уатТипыТС.Наименование = &Наименование
			|	И уатТипыТС.ЭтоГруппа");
			Запрос.УстановитьПараметр("Наименование", СокрЛП(тГруппа));
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				мГруппа = Выборка.Ссылка;
			Иначе
				мГруппа = ТекущийСправочник.СоздатьГруппу();
				мГруппа.Наименование = СокрЛП(тГруппа);
				мГруппа.Записать();
			КонецЕсли;
			ТипТС.Родитель = мГруппа.Ссылка;
		КонецЕсли;
		
	    ЗаполнитьЗначенияСвойств(ТипТС, ТекущиеДанные);
		ТипТС.Записать();
	
		Если НомерСтроки = Элементы.СписокТиповТС.ТекущаяСтрока Или ТекущаяСсылка = Неопределено Тогда
			ТекущаяСсылка = ТипТС.Ссылка;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТекущаяСсылка;

КонецФункции

&НаКлиенте
Процедура ОбработатьВыборВСпискеТиповТС(СтандартнаяОбработка = Неопределено)
		
	// Добавление элемента справочника и вывод результата пользователю.
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСсылка = СохранитьВыбранныеСтроки(Элементы.СписокТиповТС.ВыделенныеСтроки);
	
	ОповеститьОВыборе(ТекущаяСсылка);
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Типы кузовов добавлены.'"), , , БиблиотекаКартинок.Информация32);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
