
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗакрыватьПриВыборе = Ложь;
	ИмяМакета = "МакетТиповПунктов";
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
	уатТипыПунктов = Справочники.уатТипыПунктов;
	
	// Заполняет список типов кузовов из макета.
	МакетДанных = уатТипыПунктов.ПолучитьМакет(ИмяМакета);
	КолСтрок = МакетДанных.ВысотаТаблицы;
	Для сч = 1 По КолСтрок Цикл
		НоваяСтрока = ТипыТС.Добавить();
		НоваяСтрока.Наименование = МакетДанных.Область(сч,1,сч,1).Текст;
		
		Макет    = МакетДанных.Область(сч,2,сч,2).Текст;
		Если Макет = "КартинкаКонтрегент" Тогда
			Макет = "КартинкаКонтрагент";
		Конецесли;
		
		ТекМакет = уатТипыПунктов.ПолучитьМакет(Макет);
		ТекстМакета          = ТекМакет.ПолучитьТекст();
		
		ДвоичныеДанныеМакета = ПолучитьДвоичныеДанныеИзСтроки(ТекстМакета);
		АдресКартинки        = ПоместитьВоВременноеХранилище(ДвоичныеДанныеМакета, Новый УникальныйИдентификатор);
		
		НоваяСтрока.Картинка             = АдресКартинки;
		НоваяСтрока.НаименованиеКартинки = МакетДанных.Область(сч,3,сч,3).Текст;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СохранитьВыбранныеСтроки(Знач ВыбранныеСтроки)
	
	ТекущаяСсылка = Неопределено;
	
	ТекущийСправочник = Справочники.уатТипыПунктов;
	
	Для каждого НомерСтроки Из ВыбранныеСтроки Цикл
		ТекущиеДанные = ТипыТС.НайтиПоИдентификатору(НомерСтроки);
		
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
		ТипТС.Наименование         = ТекущиеДанные.Наименование;
		ТипТС.НаименованиеКартинки = ТекущиеДанные.НаименованиеКартинки;
		ТипТС.Картинка             = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(ТекущиеДанные.Картинка),
			Новый СжатиеДанных(9));

		ТипТС.Записать();
		
	КонецЦикла;
	
	Возврат ТекущаяСсылка;

КонецФункции

&НаКлиенте
Процедура ОбработатьВыборВСпискеТиповТС(СтандартнаяОбработка = Неопределено)
		
	// Добавление элемента справочника и вывод результата пользователю.
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСсылка = СохранитьВыбранныеСтроки(Элементы.СписокТиповТС.ВыделенныеСтроки);
	
	ОповеститьОВыборе(ТекущаяСсылка);
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Типы пунктов добавлены.'"), , , БиблиотекаКартинок.Информация32);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
