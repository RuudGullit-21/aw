
#Область ПеременныеФормы

&НаКлиенте
Перем сЗагруженныеДанныеВыпискаОпераций;

&НаКлиенте
Перем сЗагруженныеДанныеЛогическийОтчет;

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		АвтоТест = Истина;
	КонецЕсли;

	ПрофильОбменаВыпискаОпераций = Справочники.уатПрофилиОбменаСВнешнимиСистемами.ПлатонВыпискаОпераций;
	ПрофильОбменаЛогическийОтчет = Справочники.уатПрофилиОбменаСВнешнимиСистемами.ПлатонЛогистическийОтчет;

	ЗаполнитьСоответствияКолонокВыпискаОперацийСервер();
	ЗаполнитьСоответствияКолонокЛогистическийОтчетСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВладелецФормы = Неопределено Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("en='Immediate opening for this object is prohibited!';ru='Непосредственное открытие для данного объекта запрещено!'"), 10);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	сЗагруженныеДанныеВыпискаОпераций = Новый Соответствие;
	сЗагруженныеДанныеЛогическийОтчет = Новый Соответствие;
	ЗагрузитьНастройки();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяФайлаВыпискаОперацийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура("ИмяПроцедуры", "ИзменитьФайлПослеВыбораФайла");
	Обработчик        = Новый ОписаниеОповещения("ПоказатьДиалогВыбораФайла", ЭтотОбъект, ПараметрыОткрытия);
	НачатьПодключениеРасширенияРаботыСФайлами(Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаЛогистическийОтчетНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура("ИмяПроцедуры", "ИзменитьФайлПослеВыбораФайлаЛО");
	Обработчик        = Новый ОписаниеОповещения("ПоказатьДиалогВыбораФайла", ЭтотОбъект, ПараметрыОткрытия);
	НачатьПодключениеРасширенияРаботыСФайлами(Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрофильОбменаВыпискаОперацийПриИзменении(Элемент)
	ЗаполнитьСоответствияКолонокВыпискаОперацийСервер();
	СохранитьНастройки();
КонецПроцедуры

&НаКлиенте
Процедура ПрофильОбменаЛогическийОтчетПриИзменении(Элемент)
	ЗаполнитьСоответствияКолонокЛогистическийОтчетСервер();
	СохранитьНастройки();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьЗагрузку(Команда)
	ПустаяСтрокаИмяФайлаВыпискаОпераций    = ПустаяСтрока(ИмяФайлаВыпискаОпераций);
	ПустаяСтрокаИмяФайлаЛогистическийОтчет = ПустаяСтрока(ИмяФайлаЛогистическийОтчет);
	мсвЗагруженныеДанные = Новый Массив();

	Если ПустаяСтрокаИмяФайлаВыпискаОпераций
		И ПустаяСтрокаИмяФайлаЛогистическийОтчет Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru = 'Не указано имя файла!'"));
		Возврат;
	КонецЕсли;
	
	СтрокаОшибки = "";
	Если НЕ ПустаяСтрокаИмяФайлаВыпискаОпераций Тогда
		Попытка
			ВыполнитьЗагрузкуВыпискиОпераций(СтрокаОшибки, мсвЗагруженныеДанные);
		Исключение
			СтрокаОшибки = Нстр("ru = 'Данные документа ""Выписка операций"" не были загружены. Проверьте настройки профиля обмена.'");
		КонецПопытки;
	КонецЕсли;
	
	Если НЕ ПустаяСтрокаИмяФайлаЛогистическийОтчет Тогда
		Попытка
			ВыполнитьЗагрузкуЛогистическогоОтчета(СтрокаОшибки, мсвЗагруженныеДанные);
		Исключение
			СтрокаОшибки = Нстр("ru = 'Данные документа ""Логистический отчет"" не были загружены. Проверьте настройки профиля обмена.'");
		КонецПопытки;
	КонецЕсли;
			
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗагрузитьНастройки()
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураНастроек    = ХранилищеНастроекДанныхФорм.Загрузить("Документ.уатОтчетСистемыПлатон.Форма.ФормаЗагрузки", "уатОтчетСистемыПлатон_ОбщиеНастройки",,Пользователи.АвторизованныйПользователь());
	НастройкиНекорректны = (СтруктураНастроек = Неопределено Или ТипЗнч(СтруктураНастроек) <> Тип("Структура"));
		
	Если НЕ НастройкиНекорректны
		И СтруктураНастроек.Свойство("ПрофильОбменаВыпискаОпераций") Тогда
		ПрофильОбменаВыпискаОпераций = СтруктураНастроек.ПрофильОбменаВыпискаОпераций;
	КонецЕсли;
	
	Если НЕ НастройкиНекорректны
		И СтруктураНастроек.Свойство("ИмяФайлаВыпискаОпераций") Тогда
		ИмяФайлаВыпискаОпераций = СтруктураНастроек.ИмяФайлаВыпискаОпераций;
	КонецЕсли;
		
	Если НЕ НастройкиНекорректны
		И СтруктураНастроек.Свойство("ИмяФайлаЛогистическийОтчет") Тогда
		ИмяФайлаЛогистическийОтчет = СтруктураНастроек.ИмяФайлаЛогистическийОтчет;
	КонецЕсли;
	
	Если НЕ НастройкиНекорректны
		И СтруктураНастроек.Свойство("ПрофильОбменаЛогическийОтчет") Тогда
		ПрофильОбменаЛогическийОтчет = СтруктураНастроек.ПрофильОбменаЛогическийОтчет;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ПрофильОбменаВыпискаОпераций", ПрофильОбменаВыпискаОпераций);
	СтруктураНастроек.Вставить("ИмяФайлаВыпискаОпераций",      ИмяФайлаВыпискаОпераций);
	СтруктураНастроек.Вставить("ИмяФайлаЛогистическийОтчет",   ИмяФайлаЛогистическийОтчет);
	СтруктураНастроек.Вставить("ПрофильОбменаЛогическийОтчет", ПрофильОбменаЛогическийОтчет);
	
	ХранилищеНастроекДанныхФорм.Сохранить("Документ.уатОтчетСистемыПлатон.Форма.ФормаЗагрузки", "уатОтчетСистемыПлатон_ОбщиеНастройки",
								СтруктураНастроек,,Пользователи.АвторизованныйПользователь());
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСоответствияКолонокВыпискаОперацийСервер()
	
	СоответствиеКолонокВыпискаОпераций.Очистить();
	Если ЗначениеЗаполнено(ПрофильОбменаВыпискаОпераций) Тогда
		СоответствиеКолонокВыпискаОпераций.Загрузить(ПрофильОбменаВыпискаОпераций.СоответствиеКолонок.Выгрузить());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСоответствияКолонокЛогистическийОтчетСервер()
	
	СоответствиеКолонокЛогистическийОтчет.Очистить();
	Если ЗначениеЗаполнено(ПрофильОбменаЛогическийОтчет) Тогда
		СоответствиеКолонокЛогистическийОтчет.Загрузить(ПрофильОбменаЛогическийОтчет.СоответствиеКолонок.Выгрузить());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьФайлПослеВыбораФайла(Результат, ДопПараметры) Экспорт
		
	Если Результат = Неопределено Тогда 
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("en='You must select a file';ru='Необходимо выбрать файл'");
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	ИмяФайлаВыпискаОпераций = Результат[0];
	СохранитьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьФайлПослеВыбораФайлаЛО(Результат, ДопПараметры) Экспорт
		
	Если Результат = Неопределено Тогда 
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("en='You must select a file';ru='Необходимо выбрать файл'");
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	ИмяФайлаЛогистическийОтчет = Результат[0];
	СохранитьНастройки();

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуВыпискиОпераций(СтрокаОшибки, Массив)
	
	СтрокаОшибки = "";
	ВыполнитьЗагрузкуДанных(ИмяФайлаВыпискаОпераций, 1, СтрокаОшибки, Массив);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуЛогистическогоОтчета(СтрокаОшибки, Массив)
	
	СтрокаОшибки = "";
	ВыполнитьЗагрузкуДанных(ИмяФайлаЛогистическийОтчет, 2, СтрокаОшибки, Массив);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуДанных(ИмяФайла, ТипОперации, СтрокаОшибки = "", Массив)
	ТипФайла = Прав(ИмяФайла,3);
	#Если МобильныйКлиент ИЛИ МобильноеПриложениеКлиент Тогда
		Файл = Новый Файл(ИмяФайла);
		ПредставлениеНаМобильномУстройстве = Файл.ПолучитьПредставлениеФайлаБиблиотекиМобильногоУстройства();
		ТипФайла = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ПредставлениеНаМобильномУстройстве);
	#КонецЕсли  
	
	Если ТипФайла = "csv" Тогда	
		
		ДопПараметры = Новый Структура();
		ДопПараметры.Вставить("ИмяФайла", ИмяФайла);
		ДопПараметры.Вставить("СтрокаОшибки", СтрокаОшибки);
		ДопПараметры.Вставить("ТипОперации", ТипОперации);
		ДопПараметры.Вставить("Массив", Массив);
		
		Обработчик = Новый ОписаниеОповещения("ПрочитатьДанныеИзФайлаПослеПодключения", ЭтотОбъект, ДопПараметры);
		НачатьПодключениеРасширенияРаботыСФайлами(Обработчик);
	Иначе
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст  = НСтр("en='You must select a CSV file';ru='Необходимо выбрать файл CSV'");
		Сообщение.Сообщить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуДанныхЗавершение(ДвоичныеДанные, ДопПараметры) Экспорт
	
	Если ДвоичныеДанные <> Неопределено Тогда
		Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
		РасширениеФайла = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ДопПараметры.ИмяФайла));
		ЗагружаемыйФайл = ВыполнитьЗагрузкуДанныхСервер(ДопПараметры.ИмяФайла, Адрес, РасширениеФайла, ДопПараметры.СтрокаОшибки);
		ВыполнитьЗагрузкуДанныхCSV(ДопПараметры.ИмяФайла, ДопПараметры.ТипОперации, ДопПараметры.СтрокаОшибки, ЗагружаемыйФайл, ДопПараметры.Массив);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыполнитьЗагрузкуДанныхСервер(ИмяФайла, Адрес, Расширение, СтрокаОшибки = "")
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Расширение);
	ДвоичныеДанные = ПолучитьИЗВременногоХранилища(Адрес); // ДвоичныеДанные
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	
	ЗагружаемыйФайл = Новый ТекстовыйДокумент;
	Попытка
		ЗагружаемыйФайл.Прочитать(ИмяВременногоФайла);
	Исключение
		СтрокаОшибки = Нстр("ru = 'Ошибка совместного доступа к файлу'") + " " + ИмяФайла;
	КонецПопытки;
	
	Возврат ЗагружаемыйФайл;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьЗагрузкуДанныхCSV(ИмяФайла, ТипОперации, СтрокаОшибки, ЗагружаемыйФайл, Массив)
	
	СоответствиеКолонокВрем.Очистить();
	
	Если ТипОперации = 1 Тогда
		СоответствиеКолонок	 = СоответствиеКолонокВыпискаОпераций;
		ПрофильОбмена		 = ПрофильОбменаВыпискаОпераций;
	Иначе
		СоответствиеКолонок	 = СоответствиеКолонокЛогистическийОтчет;
		ПрофильОбмена		 = ПрофильОбменаЛогическийОтчет;
	КонецЕсли;
	
	Для Каждого ТекСтрока Из СоответствиеКолонок Цикл
		НоваяСтрока = СоответствиеКолонокВрем.Добавить();
		НоваяСтрока.КолонкаДокумента = ТекСтрока.КолонкаДокумента;
		НоваяСтрока.ИмяКолонкиФайла = ТекСтрока.ИмяКолонкиФайла;
		НоваяСтрока.КолонкаДокументаПредставление = ТекСтрока.КолонкаДокументаПредставление;
		НоваяСтрока.НомерКолонкиФайла	 = ТекСтрока.НомерКолонкиФайла;
		НоваяСтрока.Использование		 = ТекСтрока.Использование;
	КонецЦикла;
	
	СтруктураКолонок = Новый Структура;
	Для Каждого ТекСоотв Из СоответствиеКолонокВрем Цикл
		Если НЕ ТекСоотв.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураКолонок.Вставить(ТекСоотв.КолонкаДокумента, ТекСоотв.НомерКолонкиФайла);
	КонецЦикла;

	флИспользуетсяСовмещеннаяКолонкаДатаВремя = Истина;
	
	сЗагруженныеДанные = Новый Соответствие();
	Для НомерСтроки = 1 по ЗагружаемыйФайл.КоличествоСтрок() цикл
		ТекСтрока		 = ЗагружаемыйФайл.ПолучитьСтроку(НомерСтроки);
		МассивЭлементов	 = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТекСтрока,";");
		
		Попытка
			СтрокаНезакрыта = СтрЧислоВхождений(МассивЭлементов[МассивЭлементов.Количество()-1], """") = 1;
			Если СтрокаНезакрыта Тогда
				НомерСтроки			 = НомерСтроки + 1;
				ТекСтрока			 = ЗагружаемыйФайл.ПолучитьСтроку(НомерСтроки );
				МассивЭлементовКон	 = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТекСтрока, ";");	
				
				МассивЭлементов[МассивЭлементов.Количество() - 1] = МассивЭлементов[МассивЭлементов.Количество() - 1] + " " + МассивЭлементовКон[0];
				ПерваяСтрока = Истина;
				Для Каждого ТекСтрока Из МассивЭлементовКон Цикл
					Если ПерваяСтрока Тогда
						ПерваяСтрока = Ложь;
						Продолжить;
					КонецЕсли;
					МассивЭлементов.Добавить(ТекСтрока);
				КонецЦикла;
				
				СтрокаНезакрыта = СтрЧислоВхождений(МассивЭлементов[МассивЭлементов.Количество()-1], """") = 1;
				Если СтрокаНезакрыта Тогда
					НомерСтроки			 = НомерСтроки + 1;
					ТекСтрока			 = ЗагружаемыйФайл.ПолучитьСтроку(НомерСтроки);
					МассивЭлементовКон	 = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТекСтрока, ";");	
					
					МассивЭлементов[МассивЭлементов.Количество() - 1] = МассивЭлементов[МассивЭлементов.Количество() - 1] + " " + МассивЭлементовКон[0];
					ПерваяСтрока = Истина;
					Для Каждого ТекСтрока Из МассивЭлементовКон Цикл
						Если ПерваяСтрока Тогда
							ПерваяСтрока = Ложь;
							Продолжить;
						КонецЕсли;
						МассивЭлементов.Добавить(ТекСтрока);
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
		Исключение
		КонецПопытки;
	
		Если МассивЭлементов.Количество() < 2 Тогда
			МассивЭлементов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТекСтрока,""",""");
			Если МассивЭлементов.Количество() > 0 Тогда
				МассивЭлементов[0] = СтрЗаменить(МассивЭлементов[0], """","");
				МассивЭлементов[МассивЭлементов.Количество()-1] = СтрЗаменить(МассивЭлементов[МассивЭлементов.Количество()-1], """","");
			КонецЕсли;
		КонецЕсли;
		Если МассивЭлементов.Количество() < 2 Тогда
			МассивЭлементов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрЗаменить(ТекСтрока, """", ""),",");
		КонецЕсли;

		СтруктураСтроки	 = Новый Структура;

		Если ТипОперации = 1 Тогда
			
			ДатаОперации = МассивЭлементов[СтруктураКолонок.ДатаОперации-1];
			ДатаЗаправкиСтрока	 = Лев(ДатаОперации, +10);
			ВремяЗаправкиСтрока	 = Сред(ДатаОперации,12,+8);
			
			Попытка
				Месяц_ = Число(Сред(ДатаЗаправкиСтрока, 4, 2));
				День_ = Число(Лев(ДатаЗаправкиСтрока, 2));
				Год_ = СтрЗаменить(Число(Сред(ДатаЗаправкиСтрока, 7, 4)), " ", "");
				
				Попытка
					Час_ = Число(Лев(ВремяЗаправкиСтрока, 2));
				Исключение
					Час_ = Число(Лев(ВремяЗаправкиСтрока, 1));
					ВремяЗаправкиСтрока = "0" + ВремяЗаправкиСтрока;
				КонецПопытки;
				Минута_ = Число(Сред(ВремяЗаправкиСтрока, 4, 2));
				Секунда_ = Число(Прав(ВремяЗаправкиСтрока, 2));
			Исключение
				Продолжить;
			КонецПопытки;

			ДатаОперации = Дата(Год_, Месяц_, День_, Час_, Минута_, Секунда_);
			
			СтруктураСтроки.Вставить("ДатаОперации", ДатаОперации);
			
			Попытка
				УникальныйНомерОперации = МассивЭлементов[СтруктураКолонок.УникальныйНомерОперации-1];
			Исключение
				УникальныйНомерОперации = "";
			КонецПопытки;
			СтруктураСтроки.Вставить("УникальныйНомерОперации", УникальныйНомерОперации);
			
			Попытка
				мТипОперации = МассивЭлементов[СтруктураКолонок.ТипОперации-1];
			Исключение
				мТипОперации = "";
			КонецПопытки;
			СтруктураСтроки.Вставить("ТипОперации", мТипОперации);
			
			Попытка
				ГРЗТС = МассивЭлементов[СтруктураКолонок.ГРЗТС-1];
			Исключение
				ГРЗТС = "";
			КонецПопытки;
			СтруктураСтроки.Вставить("ГРЗТС", ГРЗТС);
			
			Попытка
				ПутьПройденныйТС = Число(МассивЭлементов[СтруктураКолонок.ПутьПройденныйТС-1]);
			Исключение
				ПутьПройденныйТС = 0;
			КонецПопытки;
			СтруктураСтроки.Вставить("ПутьПройденныйТС", ПутьПройденныйТС);
			
			Попытка
				ЗачислениеНаРЗ = Число(МассивЭлементов[СтруктураКолонок.ЗачислениеНаРЗ-1]);
			Исключение
				ЗачислениеНаРЗ = 0;
			КонецПопытки;
			СтруктураСтроки.Вставить("ЗачислениеНаРЗ", ЗачислениеНаРЗ);
			
			Попытка
				СписаниеСРЗ = Число(МассивЭлементов[СтруктураКолонок.СписаниеСРЗ-1]);
			Исключение
				СписаниеСРЗ = 0;
			КонецПопытки;
			СтруктураСтроки.Вставить("СписаниеСРЗ", СписаниеСРЗ);
			
			Попытка
				НомерБУМК = МассивЭлементов[СтруктураКолонок.НомерБУМК-1];
			Исключение
				НомерБУМК = "";
			КонецПопытки;
			СтруктураСтроки.Вставить("НомерБУМК", НомерБУМК);
			
			Попытка
				ДатаВремяНачалаДвижения = СтрЗаменить(МассивЭлементов[СтруктураКолонок.ДатаВремяНачалаДвижения-1], """", "");
				ДатаЗаправкиСтрока	 = Лев(ДатаВремяНачалаДвижения, +10);
				ВремяЗаправкиСтрока	 = Сред(ДатаВремяНачалаДвижения,12,+8);
				
				Месяц_ = Число(Сред(ДатаЗаправкиСтрока, 4, 2));
				День_  = Число(Лев(ДатаЗаправкиСтрока, 2));
				Год_   = СтрЗаменить(СтрЗаменить(Число(Сред(ДатаЗаправкиСтрока, 7, 4)), " ", ""), Символы.НПП, "");
				
				Попытка
					Час_ = Число(Лев(ВремяЗаправкиСтрока, 2));
				Исключение
					Час_ = Число(Лев(ВремяЗаправкиСтрока, 1));
					ВремяЗаправкиСтрока = "0" + ВремяЗаправкиСтрока;
				КонецПопытки;
				Минута_ = Число(Сред(ВремяЗаправкиСтрока, 4, 2));
				
				ДатаВремяНачалаДвижения = Дата(Год_, Месяц_, День_, Час_, Минута_, 0);
			Исключение
				ДатаВремяНачалаДвижения = "";
			КонецПопытки;
			СтруктураСтроки.Вставить("ДатаВремяНачалаДвижения", ДатаВремяНачалаДвижения);
			
			Попытка
				ДатаВремяОкончанияДвижения = СтрЗаменить(МассивЭлементов[СтруктураКолонок.ДатаВремяОкончанияДвижения-1], """", "");
				ДатаЗаправкиСтрока	 = Лев(ДатаВремяОкончанияДвижения, +10);
				ВремяЗаправкиСтрока	 = Сред(ДатаВремяОкончанияДвижения,12,+8);
				
				Месяц_ = Число(Сред(ДатаЗаправкиСтрока, 4, 2));
				День_  = Число(Лев(ДатаЗаправкиСтрока, 2));
				Год_   = СтрЗаменить(СтрЗаменить(Число(Сред(ДатаЗаправкиСтрока, 7, 4)), " ", ""), Символы.НПП, "");
				
				Попытка
					Час_ = Число(Лев(ВремяЗаправкиСтрока, 2));
				Исключение
					Час_ = Число(Лев(ВремяЗаправкиСтрока, 1));
					ВремяЗаправкиСтрока = "0" + ВремяЗаправкиСтрока;
				КонецПопытки;
				Минута_ = Число(Сред(ВремяЗаправкиСтрока, 4, 2));
				
				ДатаВремяОкончанияДвижения = Дата(Год_, Месяц_, День_, Час_, Минута_, 0);
			Исключение
				ДатаВремяОкончанияДвижения = "";
			КонецПопытки;
			
			СтруктураСтроки.Вставить("ДатаВремяОкончанияДвижения", ДатаВремяОкончанияДвижения);
			
			сЗагруженныеДанные.Вставить(УникальныйНомерОперации,СтруктураСтроки);
		Иначе
			
			Попытка
				ДатаВремяНачалаДвижения = МассивЭлементов[СтруктураКолонок.ДатаВремяНачалаДвижения-1];
				ДатаЗаправкиСтрока	 = Лев(ДатаВремяНачалаДвижения, +10);
				ВремяЗаправкиСтрока	 = Сред(ДатаВремяНачалаДвижения,12,+8);
				
				Месяц_ = Число(Сред(ДатаЗаправкиСтрока, 4, 2));
				День_ = Число(Лев(ДатаЗаправкиСтрока, 2));
				Год_ = СтрЗаменить(Число(Сред(ДатаЗаправкиСтрока, 7, 4)), " ", "");
				
				Попытка
					Час_ = Число(Лев(ВремяЗаправкиСтрока, 2));
				Исключение
					Час_ = Число(Лев(ВремяЗаправкиСтрока, 1));
					ВремяЗаправкиСтрока = "0" + ВремяЗаправкиСтрока;
				КонецПопытки;
				Минута_ = Число(Сред(ВремяЗаправкиСтрока, 4, 2));
				ДатаВремяНачалаДвижения = Дата(Год_, Месяц_, День_, Час_, Минута_, 0);
			Исключение
				Продолжить;
			КонецПопытки;
			СтруктураСтроки.Вставить("ДатаВремяНачалаДвижения", ДатаВремяНачалаДвижения);
			
			Попытка
				ДатаВремяОкончанияДвижения = МассивЭлементов[СтруктураКолонок.ДатаВремяОкончанияДвижения-1];
				ДатаЗаправкиСтрока	 = Лев(ДатаВремяОкончанияДвижения, +10);
				ВремяЗаправкиСтрока	 = Сред(ДатаВремяОкончанияДвижения,12,+8);
				
				Месяц_ = Число(Сред(ДатаЗаправкиСтрока, 4, 2));
				День_ = Число(Лев(ДатаЗаправкиСтрока, 2));
				Год_ = СтрЗаменить(Число(Сред(ДатаЗаправкиСтрока, 7, 4)), " ", "");
				
				Попытка
					Час_ = Число(Лев(ВремяЗаправкиСтрока, 2));
				Исключение
					Час_ = Число(Лев(ВремяЗаправкиСтрока, 1));
					ВремяЗаправкиСтрока = "0" + ВремяЗаправкиСтрока;
				КонецПопытки;
				Минута_ = Число(Сред(ВремяЗаправкиСтрока, 4, 2));
				
				ДатаВремяОкончанияДвижения = Дата(Год_, Месяц_, День_, Час_, Минута_, 1);
			Исключение
				ДатаВремяОкончанияДвижения = "";
			КонецПопытки;
			СтруктураСтроки.Вставить("ДатаВремяОкончанияДвижения", ДатаВремяОкончанияДвижения);
			
			Попытка
				ГРЗТС = МассивЭлементов[СтруктураКолонок.ГРЗТС-1];
			Исключение
				ГРЗТС = "";
			КонецПопытки;
			СтруктураСтроки.Вставить("ГРЗТС", ГРЗТС);
			
			Попытка
				НомерБУМК = МассивЭлементов[СтруктураКолонок.НомерБУМК-1];
			Исключение
				НомерБУМК = "";
			КонецПопытки;
			СтруктураСтроки.Вставить("НомерБУМК", НомерБУМК);
			
			Попытка
				ПутьПройденныйТС = Число(МассивЭлементов[СтруктураКолонок.ПутьПройденныйТС-1]);
			Исключение
				ПутьПройденныйТС = 0;
			КонецПопытки;
			СтруктураСтроки.Вставить("ПутьПройденныйТС", ПутьПройденныйТС);
			
			Попытка
				НаименованиеАвтомобильнойДороги = МассивЭлементов[СтруктураКолонок.НаименованиеАвтомобильнойДороги-1];
			Исключение
				НаименованиеАвтомобильнойДороги = "";
			КонецПопытки;
			СтруктураСтроки.Вставить("НаименованиеАвтомобильнойДороги", НаименованиеАвтомобильнойДороги);
			
			Попытка
				УникальныйНомерОперации = МассивЭлементов[СтруктураКолонок.УникальныйНомерОперации-1];
			Исключение
				УникальныйНомерОперации = "";
			КонецПопытки;
			СтруктураСтроки.Вставить("УникальныйНомерОперации", УникальныйНомерОперации);
			
			Попытка
				КоординатыВъездаНаТарифицируемыйУчасток = МассивЭлементов[СтруктураКолонок.КоординатыВъездаНаТарифицируемыйУчасток-1];
				
				ЛатВъездаНаТарифицируемыйУчасток = 0;
				ЛонВъездаНаТарифицируемыйУчасток = 0;
				ДесериализоватьКоординаты(КоординатыВъездаНаТарифицируемыйУчасток, ЛатВъездаНаТарифицируемыйУчасток, ЛонВъездаНаТарифицируемыйУчасток);
			Исключение
				ЛатВъездаНаТарифицируемыйУчасток = 0;
				ЛонВъездаНаТарифицируемыйУчасток = 0;
			КонецПопытки;
			СтруктураСтроки.Вставить("ЛатВъездаНаТарифицируемыйУчасток", ЛатВъездаНаТарифицируемыйУчасток);
			СтруктураСтроки.Вставить("ЛонВъездаНаТарифицируемыйУчасток", ЛонВъездаНаТарифицируемыйУчасток);

			Попытка
				КоординатыСъездаСТарифицируемогоУчастка = МассивЭлементов[СтруктураКолонок.КоординатыСъездаСТарифицируемогоУчастка-1];
				
				ЛатСъездаСТарифицируемогоУчастка = 0;
				ЛонСъездаСТарифицируемогоУчастка = 0;
				ДесериализоватьКоординаты(КоординатыСъездаСТарифицируемогоУчастка, ЛатСъездаСТарифицируемогоУчастка, ЛонСъездаСТарифицируемогоУчастка);
			Исключение
				ЛатСъездаСТарифицируемогоУчастка = 0;
				ЛонСъездаСТарифицируемогоУчастка = 0;
			КонецПопытки;
			СтруктураСтроки.Вставить("ЛатСъездаСТарифицируемогоУчастка", ЛатСъездаСТарифицируемогоУчастка);
			СтруктураСтроки.Вставить("ЛонСъездаСТарифицируемогоУчастка", ЛонСъездаСТарифицируемогоУчастка);


			сЗагруженныеДанные.Вставить(УникальныйНомерОперации,СтруктураСтроки);
		КонецЕсли;
	КонецЦикла;
	
	Если ТипОперации = 1 Тогда
		сЗагруженныеДанныеВыпискаОпераций = сЗагруженныеДанные;	
		Если ПустаяСтрока(ИмяФайлаЛогистическийОтчет) Тогда
			ОбработкаЗагруженныхДанных(СтрокаОшибки, Массив);
		КонецЕсли;
	Иначе
		сЗагруженныеДанныеЛогическийОтчет = сЗагруженныеДанные;
		ОбработкаЗагруженныхДанных(СтрокаОшибки, Массив);
	КонецЕсли;
		
КонецПроцедуры 

&НаКлиенте
Процедура ОбработкаЗагруженныхДанных(СтрокаОшибки, мсвЗагруженныеДанные)
	
	ПустаяСтрокаИмяФайлаЛогистическийОтчет = ПустаяСтрока(ИмяФайлаЛогистическийОтчет);
	ПустаяСтрокаИмяФайлаВыпискаОпераций = ПустаяСтрока(ИмяФайлаВыпискаОпераций);


	Если ЗначениеЗаполнено(СтрокаОшибки) Тогда
		ПоказатьПредупреждение(Неопределено, СтрокаОшибки);
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрокаИмяФайлаЛогистическийОтчет Тогда
		мсвЗагруженныеДанныеВыпискаОпераций = Новый массив();
		Для Каждого ТекСтрока Из сЗагруженныеДанныеВыпискаОпераций Цикл
			мсвЗагруженныеДанныеВыпискаОпераций.Добавить(ТекСтрока.Значение);
		КонецЦикла;
		Закрыть(мсвЗагруженныеДанныеВыпискаОпераций);
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрокаИмяФайлаВыпискаОпераций Тогда
		мсвЗагруженныеДанныеЛогическийОтчет = Новый Массив();
		Для Каждого ТекСтрока Из сЗагруженныеДанныеЛогическийОтчет Цикл
			мсвЗагруженныеДанныеЛогическийОтчет.Добавить(ТекСтрока.Значение);
		КонецЦикла;
		Закрыть(мсвЗагруженныеДанныеЛогическийОтчет);
		Возврат;
	КонецЕсли;

	мсвЗагруженныеДанные = Новый Массив();
	Для Каждого ТекСтрока Из сЗагруженныеДанныеВыпискаОпераций Цикл
		СтруктураСтроки		 = Новый Структура("ДатаОперации,УникальныйНомерОперации,ТипОперации,ГРЗТС,
		|ПутьПройденныйТС,ЗачислениеНаРЗ,СписаниеСРЗ,НомерБУМК,ДатаВремяНачалаДвижения,ДатаВремяОкончанияДвижения,
		|НаименованиеАвтомобильнойДороги,ЛатВъездаНаТарифицируемыйУчасток,ЛонВъездаНаТарифицируемыйУчасток,ЛатСъездаСТарифицируемогоУчастка,ЛонСъездаСТарифицируемогоУчастка");

		ЗаполнитьЗначенияСвойств(СтруктураСтроки, ТекСтрока.Значение);
		ЗагруженныеДанныеЛогическийОтчет = сЗагруженныеДанныеЛогическийОтчет.Получить(ТекСтрока.Значение.УникальныйНомерОперации);
		Если ЗначениеЗаполнено(ЗагруженныеДанныеЛогическийОтчет) Тогда
			ЗаполнитьЗначенияСвойств(СтруктураСтроки, ЗагруженныеДанныеЛогическийОтчет);
			сЗагруженныеДанныеЛогическийОтчет.Удалить(ТекСтрока.Значение.УникальныйНомерОперации);
		КонецЕсли;
		мсвЗагруженныеДанные.Добавить(СтруктураСтроки);
	КонецЦикла;
	
	Для Каждого ТекСтрока Из сЗагруженныеДанныеЛогическийОтчет Цикл
		СтруктураСтроки		 = Новый Структура("ДатаОперации,УникальныйНомерОперации,ТипОперации,ГРЗТС,
		|ПутьПройденныйТС,ЗачислениеНаРЗ,СписаниеСРЗ,НомерБУМК,ДатаВремяНачалаДвижения,ДатаВремяОкончанияДвижения,
		|НаименованиеАвтомобильнойДороги,ЛатВъездаНаТарифицируемыйУчасток,ЛонВъездаНаТарифицируемыйУчасток,ЛатСъездаСТарифицируемогоУчастка,ЛонСъездаСТарифицируемогоУчастка");

		ЗаполнитьЗначенияСвойств(СтруктураСтроки, ТекСтрока.Значение);
		мсвЗагруженныеДанные.Добавить(СтруктураСтроки);
	КонецЦикла;
	
	Закрыть(мсвЗагруженныеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ДесериализоватьКоординаты(Знач СтрокаКоординат, Широта, Долгота)
	
	Если Не ЗначениеЗаполнено(СтрокаКоординат) Тогда 
		Возврат;
	КонецЕсли;
	
	СтрокаКоординат = СтрЗаменить(СтрокаКоординат, " ", "");
	СтрокиКоординат = СтрЗаменить(СтрокаКоординат, ",", Символы.ПС);
	
	Если Не СтрЧислоСтрок(СтрокиКоординат) = 2 Тогда 
		Возврат;
	КонецЕсли;
	
	ТекЛат = 0;
	ТекЛон = 0;
	
	Попытка
		ТекЛат = Число(СтрПолучитьСтроку(СтрокиКоординат, 1));
		ТекЛон = Число(СтрПолучитьСтроку(СтрокиКоординат, 2));
	Исключение
		Возврат;
	КонецПопытки;
	
	Широта  = ТекЛат;
	Долгота = ТекЛон;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьУстановкуРасширенияРаботыСФайламиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		НачатьУстановкуРасширенияРаботыСФайлами();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДиалогВыбораФайла(Подключено, ДополнительныеПараметры) Экспорт
	
	Если НЕ Подключено Тогда
		
		Оповещение = Новый ОписаниеОповещения("НачатьУстановкуРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ТекстСообщения = НСтр("ru = 'Для продолжении работы необходимо установить расширение для веб-клиента ""1С:Предприятие"". Установить?'");
		ПоказатьВопрос(Оповещение, ТекстСообщения, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;
	
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбора.Заголовок = НСтр("ru='Выберите файл с данными'");
	ДиалогВыбора.МножественныйВыбор = Ложь;
	ДиалогВыбора.ПроверятьСуществованиеФайла = Истина;
	ДиалогВыбора.Фильтр = "CSV (*.csv)|*.csv";
	
	ВыборФайла = Новый ОписаниеОповещения(ДополнительныеПараметры.ИмяПроцедуры, ЭтотОбъект);
	
	ДиалогВыбора.Показать(ВыборФайла);

КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьДанныеИзФайлаПослеПодключения(Подключено, ДополнительныеПараметры) Экспорт
	
	Если НЕ Подключено Тогда
		
		Оповещение = Новый ОписаниеОповещения("НачатьУстановкуРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ТекстСообщения = НСтр("ru = 'Для продолжении работы необходимо установить расширение для веб-клиента ""1С:Предприятие"". Установить?'");
		ПоказатьВопрос(Оповещение, ТекстСообщения, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;
	
	#Если МобильныйКлиент ИЛИ МобильноеПриложениеКлиент Тогда
		ДвоичныеДанные = Новый ДвоичныеДанные(ДополнительныеПараметры.ПутьКФайлу); 
		ВыполнитьЗагрузкуДанныхЗавершение(ДвоичныеДанные, ДополнительныеПараметры);
	#Иначе
		Оповещение = Новый ОписаниеОповещения("ВыполнитьЗагрузкуДанныхЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьСозданиеДвоичныхДанныхИзФайла(Оповещение, ДополнительныеПараметры.ИмяФайла);
	#КонецЕсли	
		
КонецПроцедуры

#КонецОбласти

