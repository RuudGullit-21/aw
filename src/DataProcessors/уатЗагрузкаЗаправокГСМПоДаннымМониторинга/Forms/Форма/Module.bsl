
#Область ОписаниеПеременных

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

#КонецОбласти


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
	
	РежимРаботы = 0; // Создание новых документов

	Если ДатаНач = '00010101' Тогда
		ДатаНач = ТекущаяДата() - 24*3600;
	КонецЕсли;
	Если ДатаКон = '00010101' Тогда
		ДатаКон = ДатаНач;
	КонецЕсли;
	
	ТекПользователь = ПользователиКлиентСервер.АвторизованныйПользователь();
	Организация = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(ТекПользователь, "ОсновнаяОрганизация");
	
	НастроитьКомпоновщикОтбора();
	
	НовыйЭлементОтбора = ПостроительОтчета.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТС");
	НовыйЭлементОтбора.Использование = Ложь;
	НовыйЭлементОтбора.ВидСравнения  = ВидСравненияКомпоновкиДанных.Равно;
	
	Элементы.ВариантПЛ.Видимость = ПолучитьФункциональнуюОпцию("уатИспользоватьТехнологическиеПутевыеЛисты");
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// начало блока стандартных операций
	уатЗащищенныеФункцииКлиент.уатОбработкаФормаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	// конец блока стандартных операций
	
	ВосстановитьНастройки();
	УстановитьВидимостьДоступность();
	УстановитьОтборАЗС();
	УстановитьОтборАЗССлив();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда 
		Возврат;
	КонецЕсли;
	
	СохранитьНастройки();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КнопкаВыполнитьНажатие(Кнопка)
	ОчиститьСообщения();
	ИнициализацияФормыДлительнойОперации();
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПериода(Команда)
	ДиалогПериода = Новый ДиалогРедактированияСтандартногоПериода();
	ДиалогПериода.Период.ДатаНачала    = ДатаНач;
	ДиалогПериода.Период.ДатаОкончания = ДатаКон;
	ДиалогПериода.Показать(Новый ОписаниеОповещения("НастройкаПериодаЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПериодаЗавершение(Период, ДополнительныеПараметры) Экспорт
	
	Если Период <> Неопределено Тогда
		ДатаНач = Период.ДатаНачала;
		ДатаКон = Период.ДатаОкончания;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбработанныеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекСтрока = Элементы.ОбработанныеДокументы.ТекущиеДанные;
	Если Поле.Имя = "ОбработанныеДокументыДокумент" Тогда
		ПоказатьЗначение(Неопределено, ТекСтрока.Документ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВариантПЛПриИзменении(Элемент)
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ВидЗаправкиПриИзменении(Элемент)
	УстановитьОтборАЗС();
КонецПроцедуры

&НаКлиенте
Процедура ВидСливаПриИзменении(Элемент)
	УстановитьОтборАЗССлив();
КонецПроцедуры

&НаКлиенте
Процедура РежимОбработкиСливовПриИзменении(Элемент)
	УстановитьВидимостьДоступность();
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьКомпоновщикОтбора()
	СКД = РеквизитФормыВЗначение("Объект").ПолучитьМакет("ОтборТС");
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);
	
	ПостроительОтчета.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
	Настройки = СКД.НастройкиПоУмолчанию;
	ПостроительОтчета.ЗагрузитьНастройки(Настройки);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьДоступность()
	Элементы.РежимОбработкиСливов.Видимость = (ВариантПЛ = 0);	
	СоздаватьСливыГСМ = (РежимОбработкиСливов = 0);
	
	Если НЕ Элементы.РежимОбработкиСливов.Видимость Тогда
		СоздаватьСливыГСМ = Ложь;
	КонецЕсли;
	Элементы.ГруппаЗначенияЗаполненияСливовГСМ.Видимость = СоздаватьСливыГСМ;
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("АЗСМониторинг",                    АЗСМониторинг);
	СтруктураНастроек.Вставить("АЗССливМониторинг",                АЗССливМониторинг);
	СтруктураНастроек.Вставить("ВидЗаправкиМониторинг",            ВидЗаправкиМониторинг);
	СтруктураНастроек.Вставить("ВидСливаМониторинг",               ВидСливаМониторинг);
	СтруктураНастроек.Вставить("ГлубинаПоискаПЛДоВыезда",          ГлубинаПоискаПЛДоВыезда);
	СтруктураНастроек.Вставить("ГлубинаПоискаПЛПослеВозвращения",  ГлубинаПоискаПЛПослеВозвращения);
	СтруктураНастроек.Вставить("ПересчитатьПутевыеЛисты",          ПересчитатьПутевыеЛисты);
	СтруктураНастроек.Вставить("ПроводитьСозданныеЗаправкиГСМ",    ПроводитьСозданныеЗаправкиГСМ);
	СтруктураНастроек.Вставить("СоздаватьСливыГСМ",                СоздаватьСливыГСМ);
	СтруктураНастроек.Вставить("ПроверятьНаличееДублейПоСозданнымРанееДокументам", ПроверятьНаличееДублейПоСозданнымРанееДокументам);
	
	ХранилищеНастроекДанныхФорм.Сохранить(
		"Обработка.уатЗагрузкаЗаправокГСМПоДаннымМониторинга.Форма", 
		"ОбщиеНастройки",
		СтруктураНастроек);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки()
	СтруктураНастроек = ХранилищеНастроекДанныхФорм.Загрузить(
		"Обработка.уатЗагрузкаЗаправокГСМПоДаннымМониторинга.Форма", 
		"ОбщиеНастройки");
		
	Если СтруктураНастроек <> Неопределено Тогда
		СтруктураНастроек.Свойство("АЗСМониторинг",            АЗСМониторинг);
		СтруктураНастроек.Свойство("АЗССливМониторинг",        АЗССливМониторинг);
		СтруктураНастроек.Свойство("ВидЗаправкиМониторинг",    ВидЗаправкиМониторинг);
		СтруктураНастроек.Свойство("ВидСливаМониторинг",       ВидСливаМониторинг);
		СтруктураНастроек.Свойство("ГлубинаПоискаПЛДоВыезда",  ГлубинаПоискаПЛДоВыезда);
		СтруктураНастроек.Свойство("ГлубинаПоискаПЛПослеВозвращения",  ГлубинаПоискаПЛПослеВозвращения);
		СтруктураНастроек.Свойство("ПересчитатьПутевыеЛисты",  ПересчитатьПутевыеЛисты);
		СтруктураНастроек.Свойство("ПроводитьСозданныеЗаправкиГСМ",  ПроводитьСозданныеЗаправкиГСМ);
		СтруктураНастроек.Свойство("ПроверятьНаличееДублейПоСозданнымРанееДокументам", ПроверятьНаличееДублейПоСозданнымРанееДокументам);
		
		Если СтруктураНастроек.Свойство("СоздаватьСливыГСМ") Тогда
			СтруктураНастроек.Свойство("СоздаватьСливыГСМ", СоздаватьСливыГСМ);
		Иначе
			СоздаватьСливыГСМ = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборАЗС()
	Если ВидЗаправкиМониторинг = ПредопределенноеЗначение("Перечисление.уатВидыДвиженияГСМ.ЗаправкаСклад")
		ИЛИ ВидЗаправкиМониторинг = ПредопределенноеЗначение("Перечисление.уатВидыДвиженияГСМ.ЗаправкаПластиковаяКартаСклад")
		ИЛИ ВидЗаправкиМониторинг = ПредопределенноеЗначение("Перечисление.уатВидыДвиженияГСМ.ЗаправкаТалоны") Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ЭтоАЗССклад", Истина);
	Иначе
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ЭтоАЗССклад", Ложь);
	КонецЕсли;
	МассивПарамВыбора = Новый Массив();
	МассивПарамВыбора.Добавить(НовыйПараметр);
	Элементы.АЗСМониторинг.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПарамВыбора);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборАЗССлив()
	Если ВидСливаМониторинг = ПредопределенноеЗначение("Перечисление.уатВидыОперацийСливГСМ.НаСклад") Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ЭтоАЗССклад", Истина);
	Иначе
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ЭтоАЗССклад", Ложь);
	КонецЕсли;
	МассивПарамВыбора = Новый Массив();
	МассивПарамВыбора.Добавить(НовыйПараметр);
	Элементы.АЗССливМониторинг.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПарамВыбора);
КонецПроцедуры

#Область ПроцедурыВыводаФормыДлительнойОперацииПриПроведении

&НаКлиенте
Процедура ИнициализацияФормыДлительнойОперации()
	
	ДлительнаяОперация = ВыполнениеОбработкиНаСервере();
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьПрогрессВыполнения = Истина;

	Обработчик = Новый ОписаниеОповещения("ПроверитьВыполнениеЗадания", ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, НастройкиОжидания);
	
КонецПроцедуры

&НаСервере
Функция ВыполнениеОбработкиНаСервере()
	
	Если ДлительнаяОперация <> Неопределено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
	КонецЕсли;
	
	ОбработанныеДокументы.Очистить();
	КоличествоОбработанныхДокументов = 0;
	
	СтруктураПараметров = Новый Структура;
	
	флЕстьДопОтбор = Ложь;
	Для Каждого ТекОтбор Из ПостроительОтчета.Настройки.Отбор.Элементы Цикл
		Если ТекОтбор.Использование Тогда
			флЕстьДопОтбор = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если флЕстьДопОтбор Тогда
		СКД = РеквизитФормыВЗначение("Объект").ПолучитьМакет("ОтборТС");
		
		Настройки = ПостроительОтчета.ПолучитьНастройки();
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СКД, ПостроительОтчета.Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
		ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
		
		тблТС = Новый ТаблицаЗначений;
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		
		ПроцессорВывода.УстановитьОбъект(тблТС);
		ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
		
		мсвТС = тблТС.ВыгрузитьКолонку("Ссылка");
		СтруктураПараметров.Вставить("ТС", мсвТС);
	КонецЕсли;
	СтруктураПараметров.Вставить("РежимРаботы",           РежимРаботы);
	СтруктураПараметров.Вставить("ДатаНач",               ДатаНач);
	СтруктураПараметров.Вставить("ДатаКон",               ДатаКон);
	СтруктураПараметров.Вставить("АЗСМониторинг",         АЗСМониторинг);
	СтруктураПараметров.Вставить("АЗССливМониторинг",     АЗССливМониторинг);
	СтруктураПараметров.Вставить("ВидЗаправкиМониторинг", ВидЗаправкиМониторинг);
	СтруктураПараметров.Вставить("ВидСлива",              ВидСливаМониторинг);
	СтруктураПараметров.Вставить("Ответственный",         Пользователи.АвторизованныйПользователь());
	СтруктураПараметров.Вставить("ВидПЛприПоискеПЛдляЗаправки",                      ВариантПЛ); //учитывать только ПЛ или только ТПЛ при создании заправок ГСМ
	СтруктураПараметров.Вставить("ГлубинаПоискаПЛДоВыезда",                          ГлубинаПоискаПЛДоВыезда);
	СтруктураПараметров.Вставить("ГлубинаПоискаПЛПослеВозвращения",                  ГлубинаПоискаПЛПослеВозвращения);
	СтруктураПараметров.Вставить("ПересчитатьПутевыеЛисты",                          ПересчитатьПутевыеЛисты);
	СтруктураПараметров.Вставить("ПроводитьСозданныеЗаправкиГСМ",                    ПроводитьСозданныеЗаправкиГСМ);
	СтруктураПараметров.Вставить("ПроверятьНаличееДублейПоСозданнымРанееДокументам", ПроверятьНаличееДублейПоСозданнымРанееДокументам);
	СтруктураПараметров.Вставить("ИспользоватьДанныеССМ",                            Истина);
	СтруктураПараметров.Вставить("ОбрабатыватьРассчитанныеПутевыеЛисты",             ОбрабатыватьРассчитанныеПутевыеЛисты);
	СтруктураПараметров.Вставить("СоздаватьСливыДляОтрицательныхЗаправок",           СоздаватьСливыГСМ);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка заправок ГСМ по данным мониторинга'");
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("уатЗагрузкаПЦ.СоздатьЗаправкиГСМпоДаннымПЦиССМ",
		СтруктураПараметров, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ПроверитьВыполнениеЗадания(Операция, ДополнительныеПараметры) Экспорт
	
	Если Операция = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Операция.Статус = "Выполнено" Тогда
		ВывестиСообщенияПослеВыполнения(Операция.АдресРезультата);
	Иначе
		ВызватьИсключение Операция.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
КонецПроцедуры

// Действия после выполнения фонового задания
//
&НаКлиенте
Процедура ВывестиСообщенияПослеВыполнения(АдресРезультата)
	ДанныеФоновогоЗадания = ПолучитьИзВременногоХранилища(АдресРезультата);
	Если ТипЗнч(ДанныеФоновогоЗадания) = Тип("Структура") Тогда
		Если ДанныеФоновогоЗадания.Свойство("СообщенияОбОшибках") Тогда
			Для Каждого ТекСообщениеОшибка Из ДанныеФоновогоЗадания.СообщенияОбОшибках Цикл
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекСообщениеОшибка);
			КонецЦикла;
		КонецЕсли;
		Если ДанныеФоновогоЗадания.Свойство("ОбработанныеДокументы") Тогда
			мсвОбработанныеДокументы = ДанныеФоновогоЗадания.ОбработанныеДокументы;
			Если мсвОбработанныеДокументы.Количество() <> 0  Тогда
				Для Каждого ТекДокумент Из мсвОбработанныеДокументы Цикл
					НоваяСтрока = ОбработанныеДокументы.Добавить();
					НоваяСтрока.Документ = ТекДокумент;
				КонецЦикла;
				
				Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОбработанныеДокументы;
				КоличествоОбработанныхДокументов = мсвОбработанныеДокументы.Количество();
				
				ТекстНСТР = НСтр("en='Created documents:';ru='Обработано документов:'")  + " " + КоличествоОбработанныхДокументов;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#КонецОбласти
