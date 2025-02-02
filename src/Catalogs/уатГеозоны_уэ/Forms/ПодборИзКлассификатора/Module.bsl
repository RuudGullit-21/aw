
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗакрыватьПриВыборе = Ложь;
	ЗаполнитьТаблицуГеозон();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокВалют

&НаКлиенте
Процедура СписокГеозонВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработатьВыборВСпискеГеозон(СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВыполнить()
	
	ОбработатьВыборВСпискеГеозон();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуГеозон()
	
	МакетДанных = Справочники.уатГеозоны_уэ.ПолучитьМакет("ДанныеДляЗаполнения");
	КолСтрок = МакетДанных.ВысотаТаблицы;
	Для НомерСтроки = 1 По КолСтрок Цикл
		НоваяСтрока = Геозоны.Добавить();
		НоваяСтрока.Наименование = МакетДанных.Область(НомерСтроки, 1, НомерСтроки, 1).Текст;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СохранитьВыбранныеСтроки(Знач ВыбранныеСтроки)
	
	ТекущаяСсылка = Неопределено;

	ДанныеXML = Справочники.уатГеозоны_уэ.ПолучитьМакет("Геозоны").ПолучитьТекст();
	ЧтениеXML = Новый ЧтениеXML();
	ЧтениеXML.УстановитьСтроку(ДанныеXML);
	
	СоответвиеДанных    = Новый Соответствие(); 
	МассивКоординат     = Новый Массив();
	НаименованиеГеозоны = ""; 
	Лат = "";
	Лон = "";
	Пока ЧтениеXML.Прочитать() Цикл
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента
			И НРег(ЧтениеXML.Имя) = НРег("Name") Тогда
			ЧтениеXML.Прочитать();
			НаименованиеГеозоны = ЧтениеXML.Значение; 
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента
			И НРег(ЧтениеXML.Имя) = НРег("Coordinates") Тогда
			МассивКоординат = Новый Массив();
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента
			И НРег(ЧтениеXML.Имя) = НРег("lat") Тогда
			ЧтениеXML.Прочитать();
			Лат = Число(ЧтениеXML.Значение);
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента
			И НРег(ЧтениеXML.Имя) = НРег("lon") Тогда
			ЧтениеXML.Прочитать();
			Лон = Число(ЧтениеXML.Значение);
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента
			И НРег(ЧтениеXML.Имя) = НРег("point") Тогда
			МассивКоординат.Добавить(Новый Структура("Лат, Лон", Лат, Лон));
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента
			И НРег(ЧтениеXML.Имя) = НРег("Coordinates") Тогда
			СоответвиеДанных.Вставить(НаименованиеГеозоны, МассивКоординат);
		КонецЕсли;
	КонецЦикла;

	Для Каждого НомерСтроки Из ВыбранныеСтроки Цикл
		ТекущиеДанные = Геозоны[НомерСтроки];
		тНаименование = ТекущиеДанные.Наименование;
		
		ТекДанныеГеозоны = СоответвиеДанных.Получить(тНаименование);
		Если ТекДанныеГеозоны = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаВБазе = Справочники.уатГеозоны_уэ.НайтиПоНаименованию(СокрЛП(тНаименование), Истина);
		
		// Либо такой элемент в справочнике уже есть
		Если ЗначениеЗаполнено(СтрокаВБазе) Тогда
			Если НомерСтроки = Элементы.СписокГеозон.ТекущаяСтрока
				ИЛИ ТекущаяСсылка = Неопределено Тогда
				ТекущаяСсылка = СтрокаВБазе;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
				
		НоваяГеозона = Справочники.уатГеозоны_уэ.СоздатьЭлемент();
		НоваяГеозона.Наименование      = тНаименование;
		НоваяГеозона.ЦветЗоныХранилище = Новый ХранилищеЗначения(УстановитьСлучайныйЦветГеозоны(), Новый СжатиеДанных(9));
		Для Каждого ТекСтрока Из ТекДанныеГеозоны Цикл
			ТекКоординаты = НоваяГеозона.Координаты.Добавить();
			ТекКоординаты.Лат = ТекСтрока.Лат;
			ТекКоординаты.Лон = ТекСтрока.Лон;
		КонецЦикла;
		НоваяГеозона.Записать();
	
		Если НомерСтроки = Элементы.СписокГеозон.ТекущаяСтрока
			ИЛИ ТекущаяСсылка = Неопределено Тогда
			ТекущаяСсылка = НоваяГеозона.Ссылка;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТекущаяСсылка;

КонецФункции

&НаСервере
Функция УстановитьСлучайныйЦветГеозоны()
	
	ЦветГеозоны = уатЗащищенныеФункцииСервер_проф.СлучайноеЧисло(, 15);
	
	Если ЦветГеозоны = 0 Тогда 
		ЦветГеозоны = 16;
	КонецЕсли;
	
	ЦветГеозоны = уатЭлектронныеКартыСервер.ПолучитьЦветДокументаПоКоллекции(ЦветГеозоны);
	
	Возврат ЦветГеозоны;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьВыборВСпискеГеозон(СтандартнаяОбработка = Неопределено)
		
	// Добавление элемента справочника и вывод результата пользователю.
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСсылка = СохранитьВыбранныеСтроки(Элементы.СписокГеозон.ВыделенныеСтроки);
	
	ОповеститьОВыборе(ТекущаяСсылка);
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Геозона добавлена.'"), , , БиблиотекаКартинок.Информация32);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
