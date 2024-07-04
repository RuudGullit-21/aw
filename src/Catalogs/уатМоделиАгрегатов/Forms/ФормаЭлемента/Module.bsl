
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатСправочникФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатСправочникФормаЭлементаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	МассивПараметров = Новый Массив(7);
	МассивПараметров[0] = ""; МассивПараметров[1] = "";
	МассивПараметров[2] = ""; МассивПараметров[3] = "";
	МассивПараметров[4] = ""; МассивПараметров[5] = "";
	МассивПараметров[6] = "";
	ВремНаименование = Врег(Объект.Наименование);
	Индекс=0;
	Пока СтрДлина(ВремНаименование) > 0 Цикл
		// Удалим лидирующие пробелы
		Пока СтрДлина(ВремНаименование) > 0 И Лев(ВремНаименование, 1) = " " Цикл
			ВремНаименование = Сред(ВремНаименование, 2);
		КонецЦикла;
		// Выберем очередной параметр
		Пока СтрДлина(ВремНаименование) > 0 И Лев(ВремНаименование, 1) <> " " И Лев(ВремНаименование, 1) <> "/" Цикл
			МассивПараметров[Индекс] = МассивПараметров[Индекс] + Лев(ВремНаименование, 1);
			ВремНаименование = Сред(ВремНаименование, 2);
		КонецЦикла;
		// Удалим пробелы до разделителя
		Пока СтрДлина(ВремНаименование) > 0 И Лев(ВремНаименование, 1) = " " Цикл
			ВремНаименование = Сред(ВремНаименование, 2);
		КонецЦикла;
		// Удалим и сам разделитель
		Если СтрДлина(ВремНаименование) > 0 И Лев(ВремНаименование, 1) = "/" Тогда
			ВремНаименование = Сред(ВремНаименование, 2);
		КонецЕсли;
		// Перейдем к следующему параметру
		Индекс = Индекс + 1;
		// Проверка на перебор всех параметров
		Если Индекс = 7 Тогда
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	ИзменениеНаименованияСервер(МассивПараметров);
КонецПроцедуры

&НаКлиенте
Процедура ТипАгрегатаПриИзменении(Элемент)
	Объект.Модель          = "";
	Объект.ШинаШирина      = ПредопределенноеЗначение("Справочник.уатШиныШирина.ПустаяСсылка");
	Объект.ШинаВысота      = ПредопределенноеЗначение("Справочник.уатШиныВысота.ПустаяСсылка");
	Объект.ШинаДиаметр     = ПредопределенноеЗначение("Справочник.уатШиныРадиус.ПустаяСсылка");
	Объект.ШинаИндексНагрузки    = ПредопределенноеЗначение("Справочник.уатШиныПрофиль.ПустаяСсылка");
	Объект.ШинаИндексСкорости    = ПредопределенноеЗначение("Справочник.уатШиныИндексыСкорости.ПустаяСсылка");
	Объект.ШинаТипКонструкции    = 0;
	Объект.ШинаДополнительнаяИнформация = "";
	Объект.ШинаСезонность = 0;
	Объект.НормаПробега   = 0;
	Объект.НормаЗатрат    = 0;
	Объект.Емкость        = 0;
	Объект.СрокСлужбы     = 0;
	
	УстановитьВидимость();
	ЗаполнитьПараметрВыработки();
КонецПроцедуры

&НаКлиенте
Процедура ШинаШиринаПриИзменении(Элемент)
	ФормированиеНаименования();
КонецПроцедуры

&НаКлиенте
Процедура ШинаВысотаПриИзменении(Элемент)
	ФормированиеНаименования();
КонецПроцедуры

&НаКлиенте
Процедура ШинаДиаметрПриИзменении(Элемент)
	ФормированиеНаименования();
КонецПроцедуры

&НаКлиенте
Процедура ШинаИндексНагрузкиПриИзменении(Элемент)
	ФормированиеНаименования();
КонецПроцедуры

&НаКлиенте
Процедура МодельПриИзменении(Элемент)
	ФормированиеНаименования();
КонецПроцедуры

&НаКлиенте
Процедура ПроизводительПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.ТипАгрегата) 
		И Объект.ТипАгрегата = ПредопределенноеЗначение("Справочник.уатТипыАгрегатов.Шина") тогда
		ФормированиеНаименования();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ШинаТипКонструкцииПриИзменении(Элемент)
	ФормированиеНаименования();
КонецПроцедуры

&НаКлиенте
Процедура ШинаИндексСкоростиПриИзменении(Элемент)
	ФормированиеНаименования();
КонецПроцедуры

&НаКлиенте
Процедура ШинаДополнительнаяИнформацияПриИзменении(Элемент)
	ФормированиеНаименования();
КонецПроцедуры

&НаКлиенте
Процедура ШинаСезонностьПриИзменении(Элемент)
	ФормированиеНаименования();
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

&НаКлиенте
Процедура ИзмерениеИзносаВЧасахПриИзменении(Элемент)
	УстановитьОтображениеЕдиницыПробега();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ФормированиеНаименования()
	Объект.Наименование= СокрЛП(
		СокрЛП(Объект.Производитель)+" "+
		СокрЛП(Объект.Модель)+" "+
		СокрЛП(Объект.ШинаШирина)+"/"+
		СокрЛП(Объект.ШинаВысота)+" "+
		СокрЛП(Объект.ШинаТипКонструкции)+
		СокрЛП(Объект.ШинаДиаметр)+" "+
		СокрЛП(Объект.ШинаИндексНагрузки)+" "+
		СокрЛП(Объект.ШинаИндексСкорости)+" "+
		СокрЛП(Объект.ШинаСезонность)+" "+
		СокрЛП(Объект.ШинаДополнительнаяИнформация));
КонецПроцедуры

&НаСервере
Процедура ИзменениеНаименованияСервер(МассивПараметров)
// Найдем параметры в соответствующих справочниках
	//Ширина
	Если НЕ ПустаяСтрока(МассивПараметров[2]) Тогда
		// Параметр задан
		НоваяШирина = Справочники.уатШиныШирина.НайтиПоНаименованию(МассивПараметров[2], Ложь);
		Если (НоваяШирина <> Неопределено) И (НЕ уатОбщегоНазначения.уатЗначениеНеЗаполнено(НоваяШирина)) Тогда
			ШинаШирина = НоваяШирина;
		КонецЕсли; 
	КонецЕсли; 
	//Высота
	Если НЕ ПустаяСтрока(МассивПараметров[3]) Тогда
		// Параметр задан
		НоваяВысота = Справочники.уатШиныВысота.НайтиПоНаименованию(МассивПараметров[3], Ложь);
		Если (НоваяВысота <> Неопределено) И (НЕ уатОбщегоНазначения.уатЗначениеНеЗаполнено(НоваяВысота)) Тогда
			ШинаВысота = НоваяВысота;
		КонецЕсли; 
	КонецЕсли; 
	//Диаметр
	Если НЕ ПустаяСтрока(МассивПараметров[4]) И СтрДлина(МассивПараметров[4]) > 2 Тогда
		// Параметр задан
		Диаметр = Прав(МассивПараметров[4],СтрДлина(МассивПараметров[4])-1);
		НовыйДиаметр = Справочники.уатШиныРадиус.НайтиПоНаименованию(Диаметр, Ложь);
		Если (НовыйДиаметр <> Неопределено) И (НЕ уатОбщегоНазначения.уатЗначениеНеЗаполнено(НовыйДиаметр)) Тогда
			ШинаДиаметр = НовыйДиаметр;
		КонецЕсли; 
	КонецЕсли; 
	// Индекс скорости
	Если НЕ ПустаяСтрока(МассивПараметров[6]) Тогда
		// Параметр задан
		НовыйИндексСкорости = Справочники.уатШиныИндексыСкорости.НайтиПоНаименованию(МассивПараметров[6], Ложь);
		Если (НовыйИндексСкорости <> Неопределено) И (НЕ уатОбщегоНазначения.уатЗначениеНеЗаполнено(НовыйИндексСкорости)) Тогда
			ШинаИндексСкорости = НовыйИндексСкорости;
		КонецЕсли; 
	КонецЕсли; 
	//Индекс Нагрузки
	Если НЕ ПустаяСтрока(МассивПараметров[5]) Тогда
		// Параметр задан
		НовыйИндексНагрузки = Справочники.уатШиныПрофиль.НайтиПоНаименованию(МассивПараметров[5], Ложь);
		Если (НовыйИндексНагрузки <> Неопределено) И (НЕ уатОбщегоНазначения.уатЗначениеНеЗаполнено(НовыйИндексНагрузки)) Тогда
			ШинаИндексНагрузки = НовыйИндексНагрузки;
		КонецЕсли; 
	КонецЕсли; 
	// Сезонность не трогаем
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	Если Объект.ТипАгрегата = ПредопределенноеЗначение("Справочник.уатТипыАгрегатов.Аккумулятор") тогда
		Элементы.ГруппаАккумуляторы.Видимость = Истина;
		Элементы.ГруппаШины.Видимость         = Ложь;
		Элементы.Модель.Видимость             = Ложь;
	ИначеЕсли Объект.ТипАгрегата = ПредопределенноеЗначение("Справочник.уатТипыАгрегатов.Шина") тогда
		Элементы.ГруппаАккумуляторы.Видимость = Ложь;
		Элементы.ГруппаШины.Видимость         = Истина;
		Элементы.Модель.Видимость             = Истина;
		УстановитьОтображениеЕдиницыПробега();
	Иначе
		Элементы.ГруппаАккумуляторы.Видимость = Ложь;
		Элементы.ГруппаШины.Видимость         = Ложь;
		Элементы.Модель.Видимость             = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрВыработки()
	
	ВариантПоставкиСТД = уатОбщегоНазначенияПовтИсп.ВариантПоставкиСТД();
	
	Если Не ВариантПоставкиСТД Тогда
		Если ТипЗнч(Объект.ТипАгрегата) = Тип("СправочникСсылка.уатТипыАгрегатов") Тогда
			ПараметрВыработки = Объект.ТипАгрегата.ПараметрВыработки;
			Объект.ПараметрВыработки = ?(ЗначениеЗаполнено(ПараметрВыработки), ПараметрВыработки, Справочники.уатПараметрыВыработки.ПустаяСсылка()); 
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтображениеЕдиницыПробега()
	Если Объект.ИзмерениеИзносаВЧасах Тогда
		Элементы.НормаПробега.Заголовок = НСтр("ru = 'Норма пробега, ч'");
		Элементы.НормаЗатрат.Заголовок = НСтр("ru = 'Норма затрат, % от стоимости на 1 ч'");
	Иначе
		Элементы.НормаПробега.Заголовок = НСтр("ru = 'Норма пробега, км'");
		Элементы.НормаЗатрат.Заголовок = НСтр("ru = 'Норма затрат, % от стоимости на 1000 км'");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
