#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ Параметры.Свойство("Валюта") Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	Валюта = Параметры.Валюта;
	Если Параметры.Свойство("КратностьВалюты") Тогда
		КратностьВалюты = Параметры.КратностьВалюты;
	КонецЕсли;
	Если Параметры.Свойство("КурсВалюты") Тогда
		КурсВалюты = Параметры.КурсВалюты;
	КонецЕсли;
	Если Параметры.Свойство("ДатаУстановкиКурсаИКратности") Тогда
		ДатаУстановкиКурсаИКратности = Параметры.ДатаУстановкиКурсаИКратности;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	КурсыВалюты.Очистить();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаСтраницПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если Элементы.ГруппаСтраниц.ТекущаяСтраница = Элементы.ГруппаСтраниц.ПодчиненныеЭлементы.НаДату Тогда
		Если КурсыВалюты.Количество() = 0 Тогда
			ЗаполнитьТабКурсов();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыКурсыВалюты

&НаКлиенте
Процедура КурсыВалютыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// Заполним структуру возвращаемых параметров
	СтруктураВозвращаемыхЗначений = Новый Структура();
	СтруктураВозвращаемыхЗначений.Вставить("КратностьВалюты", ВыбраннаяСтрока.Кратность);
	СтруктураВозвращаемыхЗначений.Вставить("КурсВалюты",      ВыбраннаяСтрока.Курс);
	
	Закрыть(СтруктураВозвращаемыхЗначений);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДействиеОК(Команда)
	
	СтруктураВозвращаемыхЗначений = Новый Структура();
	СтруктураВозвращаемыхЗначений.Вставить("КратностьВалюты", КратностьВалюты);
	СтруктураВозвращаемыхЗначений.Вставить("КурсВалюты",      КурсВалюты);
	
	Закрыть(СтруктураВозвращаемыхЗначений);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаДату(Команда)
	
	// Выберем дату курса
	ПоказатьВводДаты(Новый ОписаниеОповещения("ЗаполнитьНаДатуЗавершение", ЭтотОбъект, Новый Структура("ДатаУстановкиКурсаИКратности", ДатаУстановкиКурсаИКратности)), ДатаУстановкиКурсаИКратности, "Выберите дату установки курса и кратности.", ЧастиДаты.Дата);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьНаДатуЗавершение(Дата, ДополнительныеПараметры) Экспорт
    
    ДатаУстановкиКурсаИКратности = ?(Дата = Неопределено, ДополнительныеПараметры.ДатаУстановкиКурсаИКратности, Дата);
    
    
    Если (Дата <> Неопределено) Тогда
        
        // Если дата введена, заполним значение курса и кратности
        СтруктураВалюты = ПолучитьКурсВалюты();
        КурсВалюты      = СтруктураВалюты.Курс;
        КратностьВалюты = СтруктураВалюты.Кратность;
        
    КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПолучитьКурсВалюты()

	Возврат уатОбщегоНазначенияТиповые.ПолучитьКурсВалюты(Валюта, ДатаУстановкиКурсаИКратности);

КонецФункции // ПолучитьКурсВалюты()

&НаСервере
Процедура ЗаполнитьТабКурсов()
	
	ЗапросДляПолученияКурсов = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КурсыВалют.Период,
		|	КурсыВалют.Курс,
		|	КурсыВалют.Кратность
		|ИЗ
		|	РегистрСведений.КурсыВалют КАК КурсыВалют
		|
		|ГДЕ
		|	КурсыВалют.Валюта = &Валюта");
		
	ЗапросДляПолученияКурсов.УстановитьПараметр("Валюта", Валюта);
	
	ЗначениеВДанныеФормы(ЗапросДляПолученияКурсов.Выполнить().Выгрузить(), КурсыВалюты);
	
КонецПроцедуры

#КонецОбласти
